module Admin
  module VendorProducts
    class CreateVendorProduct
      Result = Struct.new(:success?, :vendor_product, keyword_init: true)

      def self.call(params:)
        new(params: params).call
      end

      def initialize(params:)
        @params = params
      end

      def call
        vendor_product = VendorProduct.new(@params)
        if vendor_product.save
          Result.new(success?: true, vendor_product: vendor_product)
        else
          Result.new(success?: false, vendor_product: vendor_product)
        end
      end
    end
  end
end
