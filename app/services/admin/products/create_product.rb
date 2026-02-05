module Admin
  module Products
    class CreateProduct
      Result = Struct.new(:success?, :product, :error, keyword_init: true)

      def self.call(params:)
        new(params: params).call
      end

      def initialize(params:)
        @params = params
      end

      def call
        product = Product.new(@params)
        if product.save
          Result.new(success?: true, product: product)
        else
          Result.new(
            success?: false,
            product: product,
            error: product.errors.full_messages.to_sentence.presence || "Product creation failed"
          )
        end
      end
    end
  end
end
