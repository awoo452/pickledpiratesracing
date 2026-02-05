module Paypal
  class CreateOrder
    Result = Struct.new(:success?, :order_id, :error, :status, keyword_init: true)

    def self.call(product_id:, variant_id:)
      new(product_id: product_id, variant_id: variant_id).call
    end

    def initialize(product_id:, variant_id:)
      @product_id = product_id
      @variant_id = variant_id
    end

    def call
      validation = ValidatePurchase.call(product_id: @product_id, variant_id: @variant_id)
      return Result.new(success?: false, error: validation.error, status: validation.status) unless validation.success?

      client = PaypalClient.new
      order = client.create_order(
        amount: format("%.2f", validation.price),
        description: validation.product.name
      )

      Result.new(success?: true, order_id: order["id"])
    rescue PaypalClient::Error => e
      Result.new(success?: false, error: e.message, status: :bad_gateway)
    end
  end
end
