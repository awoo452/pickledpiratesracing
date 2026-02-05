class Admin::OrdersController < Admin::BaseController
  def index
    data = Admin::Orders::IndexData.call
    @orders = data.orders
  end

  def show
    data = Admin::Orders::ShowData.call(id: params[:id])
    @order = data.order
  end
end
