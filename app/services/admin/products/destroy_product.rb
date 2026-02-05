module Admin
  module Products
    class DestroyProduct
      Result = Struct.new(:success?, :product, keyword_init: true)

      def self.call(product:)
        new(product: product).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        @product.destroy
        Result.new(success?: true, product: @product)
      end
    end
  end
end
