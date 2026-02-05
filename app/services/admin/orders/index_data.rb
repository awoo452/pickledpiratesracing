module Admin
  module Orders
    class IndexData
      Result = Struct.new(:orders, keyword_init: true)

      def self.call
        new.call
      end

      def call
        Result.new(orders: Order.includes(:user, :order_items).order(created_at: :desc))
      end
    end
  end
end
