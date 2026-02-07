class PaypalController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :orders, :capture ]
  before_action :authenticate_user_json!

  def orders
    result = Paypal::CreateOrder.call(
      product_id: params[:product_id],
      variant_id: params[:variant_id]
    )

    if result.success?
      render json: { id: result.order_id }
    else
      render_error(result.error, result.status || :unprocessable_entity)
    end
  end

  def capture
    result = Paypal::CaptureOrder.call(
      product_id: params[:product_id],
      variant_id: params[:variant_id],
      order_id: params[:id],
      user: current_user
    )

    if result.success?
      render json: { status: "ok", order_id: result.order.id }
    else
      render_error(result.error, result.status || :unprocessable_entity)
    end
  end

  private

  def authenticate_user_json!
    return if user_signed_in?

    render json: { error: "Please either sign up or sign into the Pickled Pirates website to purchase. See Account Menu to get started." }, status: :unauthorized
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
