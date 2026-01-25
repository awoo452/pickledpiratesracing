class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_variant

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :price_at_purchase, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
