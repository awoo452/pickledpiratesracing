class Video < ApplicationRecord
  CATEGORIES = {
    "featured" => "Featured",
    "track" => "The Track",
    "pits" => "The Pits",
    "food" => "The Food",
    "events" => "Events",
    "past_events" => "Past Events",
    "shop_time" => "Shop Time",
    "car_show" => "Car Show",
    "minibikes" => "Minibikes",
    "burnouts" => "Burnouts"
  }.freeze

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES.keys }
  validates :start_seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validate :youtube_source_present

  private

  def youtube_source_present
    return if youtube_id.present? || youtube_playlist_id.present?
    errors.add(:base, "youtube_id or youtube_playlist_id is required")
  end
end
