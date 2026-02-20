class Product < ApplicationRecord
    has_many :product_variants, dependent: :destroy
    before_validation :set_slug, on: :create
    before_destroy :delete_s3_images

    validates :name, presence: true
    validates :price, presence: true, unless: :price_hidden?
    validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :slug, presence: true, uniqueness: true

    def set_slug
        self.slug = name.parameterize if slug.blank? && name.present?
    end

    def image_url
        return nil if image_key.blank?
        S3Service.new.presigned_url(image_key)
    end

    def image_urls
        image_variants.map { |variant| variant[:url] }
    end

    def image_variants
        keys = image_variant_keys
        return [] if keys.empty?

        s3 = S3Service.new
        keys.map { |key| { key: key, url: s3.presigned_url(key) } }
    end

    private

    def image_variant_keys
        return [] if image_key.blank?

        prefix = image_key.sub(/main\..*$/, "")
        s3 = S3Service.new

        keys = s3.list_keys(prefix)

        ext_priority = {
            "webp" => 0,
            "jpg" => 1,
            "jpeg" => 2,
            "png" => 3
        }

        selected = {}

        keys.each do |k|
            match = k.match(/(main|alt\d*)\.(png|jpg|jpeg|webp)$/i)
            next unless match

            base = match[1].downcase
            ext = match[2].downcase
            priority = ext_priority[ext]
            next if priority.nil?

            current = selected[base]
            if current.nil? || priority < current[:priority]
                selected[base] = { key: k, priority: priority }
            end
        end

        selected.keys.sort_by do |base|
            if base == "main"
                [ 0, 0 ]
            else
                num_str = base.delete_prefix("alt")
                num = num_str.empty? ? 0 : num_str.to_i
                [ 1, num ]
            end
        end.map { |base| selected[base][:key] }
    end

    def delete_s3_images
        return if image_key.blank?
        return if ENV["AWS_BUCKET"].blank?

        prefix = image_key.sub(/main\..*$/, "")
        S3Service.new.delete_prefix(prefix)
    rescue StandardError => e
        Rails.logger.error("S3 delete failed for product #{id}: #{e.message}")
    end
end
