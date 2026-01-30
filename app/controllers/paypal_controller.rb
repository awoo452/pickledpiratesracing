class PaypalController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :orders, :capture ]
  before_action :authenticate_user!
  before_action :load_product

  def orders
    return if halted?
    return render_error("Unavailable", :unprocessable_entity) if @product.price_hidden?
    return render_error("Select a valid option", :unprocessable_entity) if requires_variant?

    price = price_for(@product, @variant)
    return render_error("Invalid price", :unprocessable_entity) if price <= 0

    client = PaypalClient.new
    order = client.create_order(
      amount: format("%.2f", price),
      description: @product.name
    )

    render json: { id: order["id"] }
  rescue PaypalClient::Error => e
    render_error(e.message, :bad_gateway)
  end

  def capture
    return if halted?
    return render_error("Unavailable", :unprocessable_entity) if @product.price_hidden?
    return render_error("Select a valid option", :unprocessable_entity) if requires_variant?

    price = price_for(@product, @variant)
    return render_error("Invalid price", :unprocessable_entity) if price <= 0

    client = PaypalClient.new
    capture = client.capture_order(params[:id])

    capture_amount = capture.dig("purchase_units", 0, "payments", "captures", 0, "amount", "value")
    capture_id = capture.dig("purchase_units", 0, "payments", "captures", 0, "id")
    status = capture.dig("purchase_units", 0, "payments", "captures", 0, "status")

    if capture_amount.blank? || status != "COMPLETED"
      return render_error("Payment not completed", :unprocessable_entity)
    end

    if BigDecimal(capture_amount) != price
      return render_error("Payment amount mismatch", :unprocessable_entity)
    end

    order = Order.create!(
      user: current_user,
      status: "paid",
      total: price,
      paypal_order_id: params[:id],
      paypal_capture_id: capture_id,
      payment_status: status
    )

    OrderItem.create!(
      order: order,
      product_variant: @variant,
      quantity: 1,
      price_at_purchase: price
    )

    render json: { status: "ok", order_id: order.id }
  rescue PaypalClient::Error => e
    render_error(e.message, :bad_gateway)
  end

  private

  def load_product
    @product = Product.find(params[:product_id])
    @variant = if params[:variant_id].present?
      ProductVariant.find_by(id: params[:variant_id])
    end

    if params[:variant_id].present? && @variant.blank?
      return halt_with_error("Invalid variant", :unprocessable_entity)
    end

    if @variant && @variant.product_id != @product.id
      return halt_with_error("Invalid variant", :unprocessable_entity)
    end

    if @variant && !@variant.active?
      return halt_with_error("Variant inactive", :unprocessable_entity)
    end

    if @variant && @variant.stock.present? && @variant.stock <= 0
      return halt_with_error("Out of stock", :unprocessable_entity)
    end
  end

  def requires_variant?
    @variant.blank?
  end

  def price_for(product, variant)
    if variant.present?
      variant.price_override || product.price.to_d
    else
      product.price.to_d
    end
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def halt_with_error(message, status)
    @halted = true
    render_error(message, status)
  end

  def halted?
    @halted
  end
end
