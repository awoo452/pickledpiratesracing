class Video < ApplicationRecord
  CATEGORIES = {
    "featured" => "Featured",
    "track" => "The Track",
    "pits" => "The Pits",
    "food" => "The Food",
    "events" => "Past Events"
  }.freeze

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES.keys }
  validate :youtube_source_present

  private

  def youtube_source_present
    return if youtube_id.present? || youtube_playlist_id.present?
    errors.add(:base, "youtube_id or youtube_playlist_id is required")
  end
end
