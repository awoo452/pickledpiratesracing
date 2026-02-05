module Products
  class IndexData
    Result = Struct.new(:products, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(products: Product.all)
    end
  end
end
