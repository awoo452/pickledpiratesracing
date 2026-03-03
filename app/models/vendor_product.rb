class VendorProduct < ApplicationRecord
  belongs_to :vendor
  belongs_to :product_variant

  before_save :stamp_price_updated_at, if: :price_fields_changed?
  after_commit :refresh_pricing, on: [ :create, :update, :destroy ]

  validates :vendor_id, uniqueness: { scope: :product_variant_id }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :msrp, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :min_order_quantity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :lead_time_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  private

  def price_fields_changed?
    return false unless will_save_change_to_unit_cost? || will_save_change_to_msrp?

    unit_cost.present? || msrp.present?
  end

  def stamp_price_updated_at
    self.price_updated_at = Time.current
  end

  def refresh_pricing
    return if product_variant.blank?

    product_variant.apply_pricing!
    product_variant.product&.recalculate_pricing!
  end
end
