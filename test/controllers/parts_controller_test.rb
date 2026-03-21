require "test_helper"

class PartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get parts_url
    assert_response :success
  end

  test "should get new" do
    get new_part_url
    assert_response :success
  end

  test "should create part" do
    assert_difference("Part.count") do
      post parts_url, params: {
        part: {
          part: "Engine block",
          description: "Rebuilt, ready to ship",
          price: 100.0,
          contact_info: "test@example.com",
          era: "classic",
          disclaimer_ack: "1"
        }
      }
    end

    assert_redirected_to parts_url
  end

  test "should destroy part" do
    part = @user.parts.create!(
      part: "Old header",
      description: "Used header",
      price: 50.0,
      contact_info: "test@example.com",
      era: "retro",
      disclaimer_ack: "1"
    )

    assert_difference("Part.count", -1) do
      delete part_url(part)
    end

    assert_redirected_to parts_url
  end
end
