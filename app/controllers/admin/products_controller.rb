class Admin::ProductsController < Admin::BaseController
  before_action :set_product

  def edit
  end

  def update
    if params[:product][:image].present?
      image_type = params[:image_type] || "main"
      uploaded = params[:product][:image]

      ext = File.extname(uploaded.original_filename)
      key = "products/#{@product.slug}/#{image_type}#{ext}"

      S3Service.new.upload(uploaded, key)

      @product.update!(image_key: key) if image_type == "main"
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
