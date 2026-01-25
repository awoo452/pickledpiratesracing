class EnhancementRequest < ApplicationRecord
  validates :message, presence: true
end
