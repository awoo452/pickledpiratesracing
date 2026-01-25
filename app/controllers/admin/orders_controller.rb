class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)
  end

  def show
    @order = Order.includes(order_items: { product_variant: :product }).find(params[:id])
  end
end
