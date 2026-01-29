class Part < ApplicationRecord
  belongs_to :user

  validates :part, presence: true
  validates :description, presence: true
  validates :contact_info, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
