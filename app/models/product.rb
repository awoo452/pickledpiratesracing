class Product < ApplicationRecord
    has_many :product_variants, dependent: :destroy
    has_many :vendor_products, through: :product_variants
    has_many :vendors, through: :vendor_products
    before_validation :assign_price_from_vendors
    before_validation :set_slug, on: :create
    before_destroy :delete_s3_images
    after_commit :refresh_pricing_from_vendors, on: :update, if: :pricing_inputs_changed?

    validates :name, presence: true
    validates :price, presence: true, unless: :price_hidden?
    validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :margin_percent, numericality: { greater_than_or_equal_to: 0, less_than: 100 }, allow_nil: true
    validates :handling_fee, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :slug, presence: true, uniqueness: true
    validate :pricing_ready, unless: :price_hidden?

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

    def image_variant_keys
        build_image_variant_keys
    end

    def image_variants
        keys = image_variant_keys
        return [] if keys.empty?

        s3 = S3Service.new
        keys.map { |key| { key: key, url: s3.presigned_url(key) } }
    end

    def update_pricing_from_vendors!
        product_variants.each(&:apply_pricing!)
        refresh_price_from_variants!
    end

    def recalculate_pricing!
        update_pricing_from_vendors!
    end

    private

    def pricing_inputs_changed?
        saved_change_to_margin_percent? || saved_change_to_handling_fee?
    end

    def assign_price_from_vendors
        return if margin_percent.blank?

        prices = product_variants.map(&:suggested_price).compact
        return if prices.empty?

        self.price = prices.min
    end

    def pricing_ready
        active_variants = product_variants.select(&:active?)
        if active_variants.empty?
          errors.add(:base, "Add at least one active variant before publishing pricing.")
          return
        end

        missing = active_variants.select { |variant| variant.suggested_price.nil? }
        return if missing.empty?

        names = missing.map(&:name).join(", ")
        errors.add(:base, "Pricing missing for variants: #{names}. Add vendor costs and ensure margin is set.")
    end

    def refresh_pricing_from_vendors
        recalculate_pricing!
    end

    def refresh_price_from_variants!
        prices = product_variants.map(&:suggested_price).compact
        return if prices.empty?

        new_price = prices.min
        return if price.present? && price.to_d == new_price.to_d

        update!(price: new_price)
    end

    def build_image_variant_keys
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
