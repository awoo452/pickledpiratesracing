class S3Service
  def initialize
    @client = Aws::S3::Client.new(
      region: ENV["AWS_REGION"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    )

    @bucket = ENV["AWS_BUCKET"]
  end

  def upload(uploaded_file, key)
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
    signer = Aws::S3::Presigner.new(client: @client)
    signer.presigned_url(
      :get_object,
      bucket: @bucket,
      key: key,
      expires_in: expires_in
    )
  end

  def list_keys(prefix)
    resp = @client.list_objects_v2(
      bucket: @bucket,
      prefix: prefix
    )

    resp.contents.map(&:key)
  end

end
