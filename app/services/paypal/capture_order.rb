module Paypal
  class CaptureOrder
    Result = Struct.new(:success?, :order, :error, :status, keyword_init: true)

    def self.call(order_id:, user:, cart:)
      new(order_id: order_id, user: user, cart: cart).call
    end

    def initialize(order_id:, user:, cart:)
      @order_id = order_id
      @user = user
      @cart = cart
    end

    def call
      validation = Cart::Validate.call(cart: @cart)
      return Result.new(success?: false, error: validation.error, status: validation.status) unless validation.success?

      client = PaypalClient.new
      capture = client.capture_order(@order_id)

      capture_amount = capture.dig("purchase_units", 0, "payments", "captures", 0, "amount", "value")
      capture_id = capture.dig("purchase_units", 0, "payments", "captures", 0, "id")
      status = capture.dig("purchase_units", 0, "payments", "captures", 0, "status")

      if capture_amount.blank? || status != "COMPLETED"
        return Result.new(success?: false, error: "Payment not completed", status: :unprocessable_entity)
      end

      if BigDecimal(capture_amount) != validation.pricing.total.to_d
        return Result.new(success?: false, error: "Payment amount mismatch", status: :unprocessable_entity)
      end

      order = nil
      Order.transaction do
        validation.items.each { |item| item.variant.lock! }

        validation.items.each do |item|
          variant = item.variant
          if variant.stock.blank? || variant.stock < item.quantity
            raise ActiveRecord::Rollback, "Out of stock"
          end
        end

        validation.items.each do |item|
          variant = item.variant
          variant.update!(stock: variant.stock - item.quantity)
        end

        order = Order.create!(
          user: @user,
          status: "paid",
          total: validation.pricing.total,
          subtotal: validation.pricing.subtotal,
          shipping_total: validation.pricing.shipping,
          bulky_total: validation.pricing.bulky_fee,
          tax_total: validation.pricing.tax,
          paypal_order_id: @order_id,
          paypal_capture_id: capture_id,
          payment_status: status
        )

        validation.items.each do |item|
          OrderItem.create!(
            order: order,
            product_variant: item.variant,
            quantity: item.quantity,
            price_at_purchase: item.variant.effective_price
          )
        end
      end

      if order.nil?
        return Result.new(success?: false, error: "Out of stock", status: :unprocessable_entity)
      end

      @cart.clear
      Result.new(success?: true, order: order)
    rescue PaypalClient::Error => e
      Result.new(success?: false, error: e.message, status: :bad_gateway)
    end
  end
end
