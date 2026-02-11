class Part < ApplicationRecord
  belongs_to :user
  attr_accessor :disclaimer_ack

  ERAS = {
    "classic" => "Classic (1970 and older)",
    "retro" => "Retro (1971-2006)",
    "current" => "Current era (2007-present)"
  }.freeze

  validates :part, presence: true
  validates :description, presence: true
  validates :contact_info, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :disclaimer_ack, acceptance: true
  validates :era, inclusion: { in: ERAS.keys }

  def era_label
    ERAS.fetch(era, "Unknown era")
  end
end
