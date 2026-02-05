module Paypal
  class CaptureOrder
    Result = Struct.new(:success?, :order, :error, :status, keyword_init: true)

    def self.call(product_id:, variant_id:, order_id:, user:)
      new(product_id: product_id, variant_id: variant_id, order_id: order_id, user: user).call
    end

    def initialize(product_id:, variant_id:, order_id:, user:)
      @product_id = product_id
      @variant_id = variant_id
      @order_id = order_id
      @user = user
    end

    def call
      validation = ValidatePurchase.call(product_id: @product_id, variant_id: @variant_id)
      return Result.new(success?: false, error: validation.error, status: validation.status) unless validation.success?

      client = PaypalClient.new
      capture = client.capture_order(@order_id)

      capture_amount = capture.dig("purchase_units", 0, "payments", "captures", 0, "amount", "value")
      capture_id = capture.dig("purchase_units", 0, "payments", "captures", 0, "id")
      status = capture.dig("purchase_units", 0, "payments", "captures", 0, "status")

      if capture_amount.blank? || status != "COMPLETED"
        return Result.new(success?: false, error: "Payment not completed", status: :unprocessable_entity)
      end

      if BigDecimal(capture_amount) != validation.price
        return Result.new(success?: false, error: "Payment amount mismatch", status: :unprocessable_entity)
      end

      order = nil
      Order.transaction do
        validation.variant.lock!

        if validation.variant.stock.blank? || validation.variant.stock <= 0
          raise ActiveRecord::Rollback, "Out of stock"
        end

        validation.variant.update!(stock: validation.variant.stock - 1)

        order = Order.create!(
          user: @user,
          status: "paid",
          total: validation.price,
          paypal_order_id: @order_id,
          paypal_capture_id: capture_id,
          payment_status: status
        )

        OrderItem.create!(
          order: order,
          product_variant: validation.variant,
          quantity: 1,
          price_at_purchase: validation.price
        )
      end

      if order.nil?
        return Result.new(success?: false, error: "Out of stock", status: :unprocessable_entity)
      end

      Result.new(success?: true, order: order)
    rescue PaypalClient::Error => e
      Result.new(success?: false, error: e.message, status: :bad_gateway)
    end
  end
end
