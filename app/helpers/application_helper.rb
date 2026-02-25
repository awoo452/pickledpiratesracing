require "cgi"
require "openssl"

module ApplicationHelper
  def image_proxy_url(key, width:, height: nil, fit: nil, format: nil)
    return if key.blank?
    return key if key.to_s.match?(/\Ahttps?:\/\//)

    base = ENV["IMAGE_PROXY_BASE_URL"]
    signing_key = ENV["IMAGE_PROXY_SIGNING_KEY"]
    bucket = ENV["AWS_BUCKET"]

    unless base.present? && signing_key.present? && bucket.present?
      return s3_media_url(key)
    end

    path_key = key.to_s.sub(%r{\A/}, "")
    path = "/#{path_key}"

    params = {
      width: width,
      height: height,
      fit: fit,
      format: format
    }.compact

    query = params
      .sort_by { |k, _| k.to_s }
      .map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }
      .join("&")

    signature_base = query.present? ? "#{path}?#{query}" : path
    signature = OpenSSL::HMAC.hexdigest("sha256", signing_key, signature_base)
    final_query = query.present? ? "#{query}&signature=#{signature}" : "signature=#{signature}"

    "#{base.chomp("/")}#{path}?#{final_query}"
  end

  private

  def s3_media_url(key)
    return unless S3Service.new.configured?

    Rails.application.routes.url_helpers.s3_media_path(key: key)
  end
end
