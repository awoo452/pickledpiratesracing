require "test_helper"

class PartTest < ActiveSupport::TestCase
  test "requires required fields" do
    part = Part.new

    assert_not part.valid?
    assert_includes part.errors[:part], "can't be blank"
    assert_includes part.errors[:description], "can't be blank"
    assert_includes part.errors[:contact_info], "can't be blank"
    assert_includes part.errors[:price], "can't be blank"
    assert_includes part.errors[:disclaimer_ack], "must be accepted"
  end

  test "era label fallback" do
    part = Part.new(era: "unknown")

    assert_equal "Unknown era", part.era_label
  end
end
