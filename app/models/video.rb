class Video < ApplicationRecord
  validates :title, presence: true
  validate :youtube_source_present

  private

  def youtube_source_present
    return if youtube_id.present? || youtube_playlist_id.present?
    errors.add(:base, "youtube_id or youtube_playlist_id is required")
  end
end
