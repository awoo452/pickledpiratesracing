class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    cart = Cart::Session.new(session: session)
    @items = cart.items
    @pricing = Cart::Pricing.call(items: @items) if @items.present?
  end

  def add_item
    variant = ProductVariant.find_by(id: params[:variant_id])
    unless variant && variant.active? && variant.price_available? && !variant.product&.price_hidden?
      return redirect_back(fallback_location: products_path)
    end

    if variant.stock.blank? || variant.stock <= 0
      return redirect_back(fallback_location: products_path)
    end

    cart = Cart::Session.new(session: session)
    cart.add(variant.id, 1)
    redirect_to cart_path
  end

  def remove_item
    cart = Cart::Session.new(session: session)
    cart.remove(params[:variant_id])
    redirect_to cart_path
  end
end
