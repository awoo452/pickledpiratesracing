module Admin
  class ProductVariantsController < Admin::BaseController
    before_action :set_variant, only: [ :edit, :update ]

    def new
      @variant = ProductVariant.new
      data = Admin::ProductVariants::FormData.call
      @products = data.products
    end

    def create
      result = Admin::ProductVariants::CreateVariant.call(params: variant_params)
      @variant = result.variant

      if result.success?
        redirect_to new_admin_product_variant_path, notice: "Variant created"
      else
        data = Admin::ProductVariants::FormData.call
        @products = data.products
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      data = Admin::ProductVariants::FormData.call
      @products = data.products
    end

    def update
      result = Admin::ProductVariants::UpdateVariant.call(variant: @variant, params: variant_params)
      if result.success?
        redirect_to edit_admin_product_variant_path(@variant), notice: "Variant updated"
      else
        data = Admin::ProductVariants::FormData.call
        @products = data.products
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_variant
      @variant = ProductVariant.find(params[:id])
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
