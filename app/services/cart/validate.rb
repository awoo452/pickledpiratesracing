module Cart
  class Validate
    Result = Struct.new(:success?, :items, :pricing, :error, :status, keyword_init: true)

    def self.call(cart:)
      new(cart: cart).call
    end

    def initialize(cart:)
      @cart = cart
    end

    def call
      items = @cart.items
      return failure("Cart is empty", :unprocessable_entity) if items.empty?

      items.each do |item|
        variant = item.variant
        product = variant.product

        if product&.price_hidden?
          return failure("Unavailable", :unprocessable_entity)
        end

        unless variant.active?
          return failure("Variant inactive", :unprocessable_entity)
        end

        if variant.stock.blank? || variant.stock < item.quantity
          return failure("Out of stock", :unprocessable_entity)
        end

        unless variant.price_available?
          return failure("Pricing pending", :unprocessable_entity)
        end

        price = variant.effective_price
        if price.nil? || price.to_d <= 0
          return failure("Invalid price", :unprocessable_entity)
        end
      end

      pricing = Cart::Pricing.call(items: items)
      Result.new(success?: true, items: items, pricing: pricing)
    end

    private

    def failure(message, status)
      Result.new(success?: false, error: message, status: status)
    end
  end
end
