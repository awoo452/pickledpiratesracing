require "test_helper"

class VendorTest < ActiveSupport::TestCase
  test "requires name" do
    vendor = Vendor.new

    assert_not vendor.valid?
    assert_includes vendor.errors[:name], "can't be blank"
  end

  test "validates email format" do
    vendor = Vendor.new(name: "Vendor", email: "not-an-email")

    assert_not vendor.valid?
    assert_includes vendor.errors[:email], "is invalid"
  end
end
