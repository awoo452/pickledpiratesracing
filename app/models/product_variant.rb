class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :order_items
end
