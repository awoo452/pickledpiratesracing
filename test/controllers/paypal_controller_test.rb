require "test_helper"

class PaypalControllerTest < ActionDispatch::IntegrationTest
  test "orders requires authentication" do
    post "/paypal/orders"

    assert_response :unauthorized
    assert_match "Please either sign up", response.body
  end

  test "capture requires authentication" do
    post "/paypal/orders/order-123/capture"

    assert_response :unauthorized
    assert_match "Please either sign up", response.body
  end
end
