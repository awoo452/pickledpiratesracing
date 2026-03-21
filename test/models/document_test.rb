require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  test "requires title and body" do
    doc = Document.new

    assert_not doc.valid?
    assert_includes doc.errors[:title], "can't be blank"
    assert_includes doc.errors[:body], "can't be blank"
  end
end
