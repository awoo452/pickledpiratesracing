module Admin
  class ProductVariantsController < Admin::BaseController
    before_action :set_variant, only: [ :edit, :update ]

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

    def edit
      @products = Product.order(:name)
    end

    def update
      if @variant.update(variant_params)
        redirect_to edit_admin_product_variant_path(@variant), notice: "Variant updated"
      else
        @products = Product.order(:name)
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
