module Admin
  module VendorProducts
    class UpdateVendorProduct
      Result = Struct.new(:success?, :vendor_product, keyword_init: true)

      def self.call(vendor_product:, params:)
        new(vendor_product: vendor_product, params: params).call
      end

      def initialize(vendor_product:, params:)
        @vendor_product = vendor_product
        @params = params
      end

      def call
        if @vendor_product.update(@params)
          Result.new(success?: true, vendor_product: @vendor_product)
        else
          Result.new(success?: false, vendor_product: @vendor_product)
        end
      end
    end
  end
end
