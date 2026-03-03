module Admin
  module VendorProducts
    class IndexData
      Result = Struct.new(:vendor_products, keyword_init: true)

      def self.call
        new.call
      end

      def call
        records = VendorProduct
          .includes(:vendor, product_variant: :product)
          .left_joins(:vendor, product_variant: :product)
          .order("vendors.name ASC, products.name ASC, product_variants.name ASC")

        Result.new(vendor_products: records)
      end
    end
  end
end
