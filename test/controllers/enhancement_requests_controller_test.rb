require "test_helper"

class EnhancementRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get new" do
    sign_in users(:one)
    get new_enhancement_request_url
    assert_response :success
  end

  test "should get index" do
    sign_in users(:one)
    get enhancement_requests_url
    assert_response :success
  end

  test "should create enhancement request" do
    sign_in users(:one)

    assert_difference("EnhancementRequest.count") do
      post enhancement_requests_url,
        params: { email: "test@example.com", message: "Please add a feature." },
        headers: { "HTTP_REFERER" => enhancement_requests_url }
    end

    assert_redirected_to enhancement_requests_url
  end

  test "redirects non-admin users" do
    sign_in users(:two)
    get enhancement_requests_url
    assert_redirected_to root_url
  end
end
