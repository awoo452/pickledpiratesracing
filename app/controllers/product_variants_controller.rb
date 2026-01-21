# app/controllers/product_variants_controller.rb
class ProductVariantsController < ApplicationController
  def new
    @variant = ProductVariant.new
    @products = Product.order(:name)
  end

  def create
    @variant = ProductVariant.new(variant_params)

    if @variant.save
      redirect_to new_product_variant_path, notice: "Variant created"
    else
      @products = Product.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  private

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
