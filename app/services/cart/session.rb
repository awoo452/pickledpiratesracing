module Cart
  class Session
    Item = Struct.new(:variant, :quantity, keyword_init: true)

    def initialize(session:)
      @session = session
      @session[:cart] ||= {}
    end

    def add(variant_id, quantity = 1)
      key = variant_id.to_s
      @session[:cart][key] = @session[:cart][key].to_i + quantity.to_i
    end

    def remove(variant_id)
      @session[:cart].delete(variant_id.to_s)
    end

    def clear
      @session[:cart] = {}
    end

    def items
      ids = @session[:cart].keys.map(&:to_i)
      return [] if ids.empty?

      variants = ProductVariant.includes(:product).where(id: ids).index_by { |variant| variant.id.to_s }

      cleaned = {}
      items = []

      @session[:cart].each do |id, quantity|
        variant = variants[id.to_s]
        next if variant.nil?

        qty = quantity.to_i
        next if qty <= 0

        cleaned[id.to_s] = qty
        items << Item.new(variant: variant, quantity: qty)
      end

      @session[:cart] = cleaned
      items
    end

    def empty?
      @session[:cart].blank? || items.empty?
    end
  end
end
