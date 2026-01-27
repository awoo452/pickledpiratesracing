class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :edit, :update ]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(create_product_params)

    if @product.save
      redirect_to edit_admin_product_path(@product), notice: "Product created"
    else
      flash.now[:alert] = @product.errors.full_messages.to_sentence.presence || "Product creation failed"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    updated = false
    if product_params.key?(:price_hidden)
      unless @product.update(price_hidden: product_params[:price_hidden])
        redirect_to edit_admin_product_path(@product),
          alert: @product.errors.full_messages.to_sentence.presence || "Update failed"
        return
      end
      updated = true
    end

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
      updated = true
    end

    if updated
      redirect_to product_path(@product), notice: "Product updated"
    else
      redirect_to edit_admin_product_path(@product), alert: "No changes selected"
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def product_params
    params.fetch(:product, {}).permit(:price_hidden)
  end

  def create_product_params
    params.fetch(:product, {}).permit(:name, :description, :price, :slug, :price_hidden)
  end
end
