module Home
  class IndexData
    Result = Struct.new(:featured_products, :featured_videos, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(
        featured_products: Product.where(featured: true),
        featured_videos: Video.where(featured: true)
      )
    end
  end
end
