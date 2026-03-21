require "test_helper"

class LegalControllerTest < ActionDispatch::IntegrationTest
  test "renders terms" do
    get terms_url

    assert_response :success
    assert_match "Terms", response.body
  end

  test "renders privacy" do
    get privacy_url

    assert_response :success
    assert_match "Privacy", response.body
  end
end
