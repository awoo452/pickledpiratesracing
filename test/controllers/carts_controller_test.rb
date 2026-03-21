require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "shows cart" do
    get cart_url

    assert_response :success
  end

  test "adds item to cart" do
    variant = product_variants(:one)
    variant.update_columns(active: true, price_override: 9.99, stock: 1)
    variant.product.update_columns(price_hidden: false, price: 9.99)

    post cart_items_path, params: { variant_id: variant.id }

    assert_redirected_to cart_url
  end

  test "removes item from cart" do
    variant = product_variants(:one)
    variant.update_columns(active: true, price_override: 9.99, stock: 1)
    variant.product.update_columns(price_hidden: false, price: 9.99)

    post cart_items_path, params: { variant_id: variant.id }
    delete cart_item_path(variant.id)

    assert_redirected_to cart_url
  end
end
