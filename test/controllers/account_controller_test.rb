require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get show" do
    sign_in users(:one)
    get account_url
    assert_response :success
  end
end
