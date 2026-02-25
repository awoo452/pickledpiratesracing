class Event < ApplicationRecord
  before_destroy :delete_s3_images

  validates :title, presence: true
  validates :event_date, presence: true
  validate :link_is_http_url

  def image_url
    return nil if image_key.blank?
    return image_key if image_key.match?(%r{\Ahttps?://}i)
    return image_key if safe_local_image_key?(image_key)

    return nil unless s3_configured?

    s3_media_path_for(image_key)
  end

  def image_alt_url
    return nil if image_alt_key.blank?
    return image_alt_key if image_alt_key.match?(%r{\Ahttps?://}i)
    return image_alt_key if safe_local_image_key?(image_alt_key)

    return nil unless s3_configured?

    s3_media_path_for(image_alt_key)
  end

  private

  def safe_local_image_key?(value)
    return false if value.blank?

    value.match?(/\A[\w.\-]+\z/)
  end

  def link_is_http_url
    return if link.blank?

    uri = URI.parse(link)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(:link, "must be a valid http(s) URL")
  rescue URI::InvalidURIError
    errors.add(:link, "must be a valid http(s) URL")
  end

  def s3_media_path_for(key)
    Rails.application.routes.url_helpers.s3_media_path(key: key)
  end

  def s3_configured?
    S3Service.new.configured?
  end

  def delete_s3_images
    return if image_key.blank?
    return if ENV["AWS_BUCKET"].blank?
    return unless image_key.include?("/")

    prefix = image_key.sub(/main\..*$/, "")
    S3Service.new.delete_prefix(prefix)
  rescue StandardError => e
    Rails.logger.error("S3 delete failed for event #{id}: #{e.message}")
  end
end
