module Admin
  module Products
    class UpdateProduct
      Result = Struct.new(:success?, :product, :alert, :notice, :redirect_url, keyword_init: true)

      HEROKU_HOST = "pickledpiratesracing-prod-e5b7e4ec2418.herokuapp.com"

      def self.call(product:, params:, uploaded:, image_type:, request_host:, production:)
        new(
          product: product,
          params: params,
          uploaded: uploaded,
          image_type: image_type,
          request_host: request_host,
          production: production
        ).call
      end

      def initialize(product:, params:, uploaded:, image_type:, request_host:, production:)
        @product = product
        @params = params
        @uploaded = uploaded
        @image_type = image_type
        @request_host = request_host
        @production = production
      end

      def call
        updated = false
        alert = nil

        if @params.present?
          unless @product.update(@params)
            return Result.new(
              success?: false,
              product: @product,
              alert: @product.errors.full_messages.to_sentence.presence || "Update failed"
            )
          end
          updated = true
        end

        if @product.saved_change_to_slug? && @product.image_key.present?
          migration_alert = migrate_product_images_for_slug_change
          alert = migration_alert if migration_alert.present?
          updated = true
        end

        if @uploaded.present?
          if require_heroku_upload?
            return Result.new(
              success?: false,
              product: @product,
              redirect_url: heroku_product_edit_url,
              alert: "Uploads must happen on the Heroku admin."
            )
          end

          ext = File.extname(@uploaded.original_filename)
          key = "products/#{@product.slug}/#{@image_type}#{ext}"

          begin
            S3Service.new.upload(@uploaded, key)
          rescue StandardError => e
            Rails.logger.error("S3 upload failed for product #{@product.id}: #{e.message}")
            return Result.new(
              success?: false,
              product: @product,
              alert: "Upload failed. Please try again."
            )
          end

          @product.update!(image_key: key) if @image_type == "main"
          updated = true
        end

        if updated
          @product.recalculate_pricing!
          Result.new(success?: true, product: @product, notice: "Product updated", alert: alert)
        else
          Result.new(success?: false, product: @product, alert: "No changes selected")
        end
      end

      private

      def require_heroku_upload?
        @production && !on_heroku?
      end

      def on_heroku?
        @request_host == HEROKU_HOST
      end

      def heroku_product_edit_url
        "https://#{HEROKU_HOST}/admin/products/#{@product.id}/edit"
      end

      def migrate_product_images_for_slug_change
        old_slug, new_slug = @product.saved_change_to_slug
        return if old_slug.blank? || new_slug.blank?

        old_prefix = "products/#{old_slug}/"
        new_prefix = "products/#{new_slug}/"
        return if old_prefix == new_prefix
        return unless @product.image_key.start_with?(old_prefix)

        new_key = @product.image_key.sub(/\A#{Regexp.escape(old_prefix)}/, new_prefix)

        s3 = S3Service.new
        if s3.configured?
          begin
            s3.move_prefix(old_prefix, new_prefix)
            main_exists = s3.list_keys(new_prefix).any? { |key| key.start_with?("#{new_prefix}main.") }
            unless main_exists
              return "Slug updated, but the main image was not found after moving S3 assets. Re-upload the main image."
            end
          rescue StandardError => e
            Rails.logger.error("S3 move failed for product #{@product.id}: #{e.message}")
            return "Slug updated, but the S3 image move failed. Re-upload the main image."
          end
        end

        @product.update!(image_key: new_key)
        nil
      end
    end
  end
end
