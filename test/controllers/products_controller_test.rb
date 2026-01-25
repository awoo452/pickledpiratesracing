require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get show" do
    product = products(:one)
    get product_url(product)
    assert_response :success
  end
end
