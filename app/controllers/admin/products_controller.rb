class Admin::ProductsController < Admin::BaseController
  before_action :set_product

  def edit
  end

  def update
    if params[:product][:image].present?
        file = params[:product][:image]

        raise "Missing slug" if @product.slug.blank?

        key = "products/#{@product.slug}/main.png"

        s3 = S3Service.new
        s3.upload(file, key)

        @product.update!(image_key: key)
    end

redirect_to product_path(@product)
end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
