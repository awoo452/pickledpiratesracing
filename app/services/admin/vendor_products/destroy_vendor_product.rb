module Admin
  module VendorProducts
    class DestroyVendorProduct
      def self.call(vendor_product:)
        new(vendor_product: vendor_product).call
      end

      def initialize(vendor_product:)
        @vendor_product = vendor_product
      end

      def call
        @vendor_product.destroy
      end
    end
  end
end
