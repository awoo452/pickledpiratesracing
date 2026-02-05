module Products
  class ShowData
    Result = Struct.new(:product, :variants, keyword_init: true)

    def self.call(id:)
      new(id: id).call
    end

    def initialize(id:)
      @id = id
    end

    def call
      product = Product.find(@id)
      Result.new(
        product: product,
        variants: product.product_variants.where(active: true)
      )
    end
  end
end
