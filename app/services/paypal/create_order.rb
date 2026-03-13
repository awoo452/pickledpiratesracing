module Paypal
  class CreateOrder
    Result = Struct.new(:success?, :order_id, :error, :status, keyword_init: true)

    def self.call(cart:)
      new(cart: cart).call
    end

    def initialize(cart:)
      @cart = cart
    end

    def call
      validation = Cart::Validate.call(cart: @cart)
      return Result.new(success?: false, error: validation.error, status: validation.status) unless validation.success?

      client = PaypalClient.new
      order = client.create_order(
        amount: format("%.2f", validation.pricing.total),
        description: "Pickled Pirates Racing Cart"
      )

      Result.new(success?: true, order_id: order["id"])
    rescue PaypalClient::Error => e
      Result.new(success?: false, error: e.message, status: :bad_gateway)
    end
  end
end
