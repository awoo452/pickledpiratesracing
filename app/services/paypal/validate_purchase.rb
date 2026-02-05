module Paypal
  class ValidatePurchase
    Result = Struct.new(:success?, :product, :variant, :price, :error, :status, keyword_init: true)

    def self.call(product_id:, variant_id:)
      new(product_id: product_id, variant_id: variant_id).call
    end

    def initialize(product_id:, variant_id:)
      @product_id = product_id
      @variant_id = variant_id
    end

    def call
      product = Product.find(@product_id)
      variant = @variant_id.present? ? ProductVariant.find_by(id: @variant_id) : nil

      if @variant_id.present? && variant.blank?
        return Result.new(success?: false, error: "Invalid variant", status: :unprocessable_entity)
      end

      if variant && variant.product_id != product.id
        return Result.new(success?: false, error: "Invalid variant", status: :unprocessable_entity)
      end

      if variant && !variant.active?
        return Result.new(success?: false, error: "Variant inactive", status: :unprocessable_entity)
      end

      if variant && (variant.stock.blank? || variant.stock <= 0)
        return Result.new(success?: false, error: "Out of stock", status: :unprocessable_entity)
      end

      if product.price_hidden?
        return Result.new(success?: false, error: "Unavailable", status: :unprocessable_entity)
      end

      if variant.blank?
        return Result.new(success?: false, error: "Select a valid option", status: :unprocessable_entity)
      end

      price = price_for(product, variant)
      if price <= 0
        return Result.new(success?: false, error: "Invalid price", status: :unprocessable_entity)
      end

      Result.new(success?: true, product: product, variant: variant, price: price)
    end

    private

    def price_for(product, variant)
      if variant.present?
        variant.price_override || product.price.to_d
      else
        product.price.to_d
      end
    end
  end
end
