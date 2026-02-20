require "test_helper"

class ContactControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get new" do
    sign_in users(:one)
    get contact_url
    assert_response :success
  end

  test "should get create" do
    sign_in users(:one)
    post contact_url, params: { email: "test@example.com", message: "Hello" }
    assert_response :redirect
  end

  test "redirects unauthenticated users" do
    get contact_url
    assert_response :redirect
  end
end
