class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :vendor_products, dependent: :destroy
  has_many :vendors, through: :vendor_products

  validates :name, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_override, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :weight_ounces, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def display_name
    "#{product&.name || "Product"} — #{name}"
  end

  def vendor_unit_cost
    vendor_products.where.not(unit_cost: nil).minimum(:unit_cost)
  end

  def current_price
    effective_price
  end

  def price_available?
    price_override.present? || suggested_price.present?
  end

  def effective_price
    price_override.presence || suggested_price || product&.price
  end

  def handling_fee_amount
    product&.handling_fee || 0
  end

  def target_margin_percent
    product&.margin_percent
  end

  def suggested_price
    cost = vendor_unit_cost
    margin = target_margin_percent
    return nil if cost.nil? || margin.nil?

    base = cost + handling_fee_amount
    return nil if base <= 0

    rate = margin.to_d / 100
    return nil if rate >= 1

    (base / (1 - rate)).round(2)
  end

  def apply_pricing!
    price = suggested_price
    return if price.nil?
    return if price_override.present? && price_override.to_d == price.to_d

    update!(price_override: price)
  end

  def actual_margin_percent
    cost = vendor_unit_cost
    price = current_price
    return nil if cost.nil? || price.nil? || price <= 0

    base = cost + handling_fee_amount
    ((price - base) / price * 100).round(1)
  end
end
