class Admin::ProductsController < Admin::BaseController
  before_action :set_product

  def edit
  end

  def update
    uploaded = params.dig(:product, :image)
    if uploaded.present?
      image_type = params[:image_type] || "main"

      ext = File.extname(uploaded.original_filename)
      key = "products/#{@product.slug}/#{image_type}#{ext}"

      begin
        S3Service.new.upload(uploaded, key)
      rescue StandardError => e
        Rails.logger.error("S3 upload failed for product #{@product.id}: #{e.message}")
        redirect_to edit_admin_product_path(@product), alert: "Upload failed. Please try again."
        return
      end

      @product.update!(image_key: key) if image_type == "main"
      redirect_to product_path(@product), notice: "Image uploaded"
      return
    end

    redirect_to edit_admin_product_path(@product), alert: "No image selected"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
