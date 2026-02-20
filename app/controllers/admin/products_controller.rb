class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :edit, :update, :destroy ]

  def index
    data = Admin::Products::IndexData.call
    @products = data.products
  end

  def new
    @product = Product.new
  end

  def create
    result = Admin::Products::CreateProduct.call(params: create_product_params)
    @product = result.product

    if result.success?
      redirect_to edit_admin_product_path(@product), notice: "Product created"
    else
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = Admin::Products::UpdateProduct.call(
      product: @product,
      params: product_params,
      uploaded: params.dig(:product, :image),
      image_type: params[:image_type] || "main",
      request_host: request.host,
      production: Rails.env.production?
    )

    if result.redirect_url.present?
      redirect_to result.redirect_url, alert: result.alert
      return
    end

    if result.success?
      redirect_to edit_admin_product_path(@product), notice: result.notice
    else
      redirect_to edit_admin_product_path(@product), alert: result.alert
    end
  end

  def destroy
    Admin::Products::DestroyProduct.call(product: @product)
    redirect_to admin_root_path, notice: "Product deleted"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.fetch(:product, {}).permit(:name, :description, :price, :slug, :featured, :price_hidden)
  end

  def create_product_params
    params.fetch(:product, {}).permit(:name, :description, :price, :slug, :price_hidden)
  end
end
