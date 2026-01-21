module Admin
  class ProductVariantsController < Admin::BaseController

  before_action :authenticate_user!
  before_action :require_admin!
  
  def new
    @variant = ProductVariant.new
    @products = Product.order(:name)
  end

  def create
    @variant = ProductVariant.new(variant_params)

    if @variant.save
      redirect_to new_admin_product_variant_path, notice: "Variant created"
    else
      @products = Product.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_admin!
    return if current_user&.admin?

    redirect_to root_path, alert: "Not authorized"
  end

  def variant_params
    params.require(:product_variant).permit(
      :product_id,
      :name,
      :price_override,
      :stock,
      :active
    )
  end
end
end