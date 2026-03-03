class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :vendor_products, dependent: :destroy
  has_many :vendors, through: :vendor_products

  validates :name, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_override, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def display_name
    "#{product&.name || "Product"} — #{name}"
  end
end
