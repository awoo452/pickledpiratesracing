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
          Result.new(success?: true, product: @product, notice: "Product updated")
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
    end
  end
end
