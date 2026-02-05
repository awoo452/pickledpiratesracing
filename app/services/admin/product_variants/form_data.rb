module Admin
  module ProductVariants
    class FormData
      Result = Struct.new(:products, keyword_init: true)

      def self.call
        new.call
      end

      def call
        Result.new(products: Product.order(:name))
      end
    end
  end
end
