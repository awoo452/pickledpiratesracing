class Product < ApplicationRecord
    has_many :product_variants, dependent: :destroy
    before_validation :set_slug, on: :create

    validates :name, presence: true
    validates :price, presence: true, unless: :price_hidden?
    validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :slug, presence: true, uniqueness: true

    def set_slug
        self.slug ||= name.parameterize if name.present?
    end

    def image_url
        return nil if image_key.blank?
        S3Service.new.presigned_url(image_key)
    end
    
    def image_urls
        return [] if image_key.blank?

        prefix = image_key.sub(/main\..*$/, "")
        s3 = S3Service.new

        keys = s3.list_keys(prefix)

        image_keys = keys.select do |k|
            k.match?(/(main|alt\d*)\.(png|jpg|jpeg|webp)$/i)
        end

        image_keys.sort_by do |k|
            if k.include?("main.")
            0
            elsif k =~ /alt\d*\./
            1
            else
            2
            end
        end.map { |k| s3.presigned_url(k) }
    end

end
