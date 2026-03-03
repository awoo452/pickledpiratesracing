module Admin
  module VendorProducts
    class FormData
      Result = Struct.new(:vendors, :variants, keyword_init: true)

      def self.call
        new.call
      end

      def call
        variants = ProductVariant
          .includes(:product)
          .references(:product)
          .order("products.name ASC, product_variants.name ASC")

        Result.new(
          vendors: Vendor.order(:name),
          variants: variants
        )
      end
    end
  end
end
