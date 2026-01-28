class Event < ApplicationRecord
  before_destroy :delete_s3_images

  validates :title, presence: true
  validates :event_date, presence: true

  def image_url
    return nil if image_key.blank?
    return image_key unless image_key.include?("/")

    S3Service.new.presigned_url(image_key)
  end

  def image_alt_url
    return nil if image_alt_key.blank?
    return image_alt_key unless image_alt_key.include?("/")

    S3Service.new.presigned_url(image_alt_key)
  end

  private

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
