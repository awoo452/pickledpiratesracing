require "test_helper"

class TaxRateTest < ActiveSupport::TestCase
  test "normalizes state" do
    rate = TaxRate.create!(state: "wa", rate: 0.09)

    assert_equal "WA", rate.state
  end

  test "for_state returns zero when missing" do
    assert_equal BigDecimal("0"), TaxRate.for_state(nil)
  end
end
