require "test_helper"

class VendorProductTest < ActiveSupport::TestCase
  test "validates numeric fields" do
    vendor = Vendor.create!(name: "Vendor")
    variant = product_variants(:one)

    record = VendorProduct.new(vendor: vendor, product_variant: variant, unit_cost: -1)

    assert_not record.valid?
    assert_includes record.errors[:unit_cost], "must be greater than or equal to 0"
  end
end
