module Cart
  class Pricing
    Result = Struct.new(
      :subtotal,
      :shipping,
      :bulky_fee,
      :tax,
      :total,
      :shippable_count,
      :bulky_count,
      keyword_init: true
    )

    def self.call(items:, tax_state: "WA")
      new(items: items, tax_state: tax_state).call
    end

    def initialize(items:, tax_state:)
      @items = items
      @tax_state = tax_state
    end

    def call
      subtotal = BigDecimal("0")
      item_count = 0
      bulky_count = 0

      @items.each do |item|
        price = item.variant.effective_price.to_d
        subtotal += price * item.quantity

        item_count += item.quantity

        bulky_count += item.quantity if item.variant.bulky?
      end

      shipping = shipping_for(item_count)
      bulky_fee = BigDecimal("5") * bulky_count

      tax_rate = TaxRate.for_state(@tax_state)
      tax = (subtotal * tax_rate).round(2)

      total = (subtotal + shipping + bulky_fee + tax).round(2)

      Result.new(
        subtotal: subtotal.round(2),
        shipping: shipping.round(2),
        bulky_fee: bulky_fee.round(2),
        tax: tax,
        total: total,
        shippable_count: item_count,
        bulky_count: bulky_count
      )
    end

    private

    def shipping_for(count)
      return BigDecimal("0") if count <= 0
      return BigDecimal("5") if count == 1

      BigDecimal("5") + (BigDecimal("4") * (count - 1))
    end
  end
end
