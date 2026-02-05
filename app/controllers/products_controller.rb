class ProductsController < ApplicationController
  def index
    data = Products::IndexData.call
    @products = data.products
  end

  def show
    data = Products::ShowData.call(id: params[:id])
    @product = data.product
    @variants = data.variants
  end
end
