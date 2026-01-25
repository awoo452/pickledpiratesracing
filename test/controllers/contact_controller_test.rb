require "test_helper"

class ContactControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get contact_url
    assert_response :success
  end

  test "should get create" do
    post contact_url, params: { email: "test@example.com", message: "Hello" }
    assert_response :redirect
  end
end
