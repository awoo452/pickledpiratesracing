require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "requires title and date" do
    event = Event.new

    assert_not event.valid?
    assert_includes event.errors[:title], "can't be blank"
    assert_includes event.errors[:event_date], "can't be blank"
  end

  test "image url returns key when not stored in s3" do
    event = Event.new(title: "Race", event_date: Date.current, image_key: "hero.jpg")

    assert_equal "hero.jpg", event.image_url
  end
end
