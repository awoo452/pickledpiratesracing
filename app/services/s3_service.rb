class S3Service
  def initialize
    @region = ENV["AWS_REGION"].presence || ENV["AWS_DEFAULT_REGION"].presence
    @access_key_id = ENV["AWS_ACCESS_KEY_ID"].presence
    @secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"].presence
    @bucket = ENV["AWS_BUCKET"].presence

    @configured = [ @region, @access_key_id, @secret_access_key, @bucket ].all?(&:present?)
    return unless @configured

    @client = Aws::S3::Client.new(
      region: @region,
      access_key_id: @access_key_id,
      secret_access_key: @secret_access_key
    )
  end

  def configured?
    @configured
  end

  def upload(uploaded_file, key)
    ensure_configured!("upload")
    File.open(uploaded_file.tempfile.path, "rb") do |file|
      @client.put_object(
        bucket: @bucket,
        key: key,
        body: file,
        content_type: uploaded_file.content_type
      )
    end

    key
  end

  def presigned_url(key, expires_in: 3600)
    return nil unless configured?

    signer = Aws::S3::Presigner.new(client: @client)
    signer.presigned_url(
      :get_object,
      bucket: @bucket,
      key: key,
      expires_in: expires_in
    )
  end

  def list_keys(prefix)
    return [] unless configured?

    resp = @client.list_objects_v2(
      bucket: @bucket,
      prefix: prefix
    )

    resp.contents.map(&:key)
  end

  def move_prefix(old_prefix, new_prefix)
    return { moved: 0, skipped: [] } unless configured?
    return { moved: 0, skipped: [] } if old_prefix == new_prefix

    old_keys = list_keys(old_prefix)
    return { moved: 0, skipped: [] } if old_keys.empty?

    existing = list_keys(new_prefix).to_h { |key| [ key, true ] }
    moved = 0
    skipped = []

    old_keys.each do |key|
      new_key = key.sub(/\A#{Regexp.escape(old_prefix)}/, new_prefix)
      next if new_key == key

      if existing[new_key]
        skipped << key
        next
      end

      @client.copy_object(
        bucket: @bucket,
        copy_source: "#{@bucket}/#{key}",
        key: new_key
      )
      @client.delete_object(bucket: @bucket, key: key)
      moved += 1
    end

    { moved: moved, skipped: skipped }
  end

  def delete_prefix(prefix)
    return unless configured?

    continuation = nil

    loop do
      resp = @client.list_objects_v2(
        bucket: @bucket,
        prefix: prefix,
        continuation_token: continuation
      )

      keys = resp.contents.map { |obj| { key: obj.key } }
      if keys.any?
        @client.delete_objects(
          bucket: @bucket,
          delete: { objects: keys, quiet: true }
        )
      end

      break unless resp.is_truncated
      continuation = resp.next_continuation_token
    end
  end

  private

  def ensure_configured!(action)
    return if configured?

    raise "S3Service not configured for #{action}. Set AWS_REGION (or AWS_DEFAULT_REGION), AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_BUCKET."
  end
end
