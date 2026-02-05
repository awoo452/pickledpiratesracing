module Admin
  module Orders
    class ShowData
      Result = Struct.new(:order, keyword_init: true)

      def self.call(id:)
        new(id: id).call
      end

      def initialize(id:)
        @id = id
      end

      def call
        Result.new(order: Order.includes(order_items: { product_variant: :product }).find(@id))
      end
    end
  end
end
