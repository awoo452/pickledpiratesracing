module Admin
  module Products
    class IndexData
      Result = Struct.new(:products, keyword_init: true)

      def self.call
        new.call
      end

      def call
        Result.new(products: Product.order(created_at: :desc))
      end
    end
  end
end
