module Admin
  module Events
    class CreateEvent
      Result = Struct.new(:success?, :event, :alert, :notice, :redirect_url, keyword_init: true)

      HEROKU_HOST = "pickledpiratesracing-prod-e5b7e4ec2418.herokuapp.com"

      def self.call(params:, request_host:, production:, image:, alt_image:)
        new(
          params: params,
          request_host: request_host,
          production: production,
          image: image,
          alt_image: alt_image
        ).call
      end

      def initialize(params:, request_host:, production:, image:, alt_image:)
        @params = params
        @request_host = request_host
        @production = production
        @image = image
        @alt_image = alt_image
      end

      def call
        event = Event.new(@params)

        unless valid_image_uploads?
          return Result.new(
            success?: false,
            event: event,
            alert: "Uploads must be JPG, PNG, or WEBP images."
          )
        end

        unless event.save
          return Result.new(
            success?: false,
            event: event,
            alert: event.errors.full_messages.to_sentence.presence || "Event creation failed"
          )
        end

        if require_heroku_upload?
          return Result.new(
            success?: true,
            event: event,
            notice: "Event created. Uploads must happen on the Heroku admin.",
            redirect_url: heroku_event_edit_url(event)
          )
        end

        handle_image_uploads(event)
        Result.new(success?: true, event: event, notice: "Event created")
      end

      private

      def require_heroku_upload?
        @production && !on_heroku? && upload_attempted?
      end

      def upload_attempted?
        @image.present? || @alt_image.present?
      end

      def on_heroku?
        @request_host == HEROKU_HOST
      end

      def heroku_event_edit_url(event)
        "https://#{HEROKU_HOST}/admin/events/#{event.id}/edit"
      end

      def handle_image_uploads(event)
        upload_event_image(event, @image, "main")
        upload_event_image(event, @alt_image, "alt")
      end

      def upload_event_image(event, uploaded, image_type)
        return if uploaded.blank?

        ext = File.extname(uploaded.original_filename)
        key = "events/#{event.id}/#{image_type}#{ext}"

        begin
          S3Service.new.upload(uploaded, key)
        rescue StandardError => e
          Rails.logger.error("S3 upload failed for event #{event.id}: #{e.message}")
          return
        end

        if image_type == "main"
          event.update!(image_key: key)
        else
          event.update!(image_alt_key: key)
        end
      end

      def valid_image_uploads?
        valid_image_upload?(@image) && valid_image_upload?(@alt_image)
      end

      def valid_image_upload?(uploaded)
        return true if uploaded.blank?

        content_type = uploaded.content_type.to_s.downcase
        ext = File.extname(uploaded.original_filename.to_s).downcase

        allowed_types = %w[image/jpeg image/jpg image/png image/webp]
        allowed_exts = %w[.jpg .jpeg .png .webp]

        allowed_types.include?(content_type) || allowed_exts.include?(ext)
      end
    end
  end
end
