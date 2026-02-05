module Admin
  module Events
    class UpdateEvent
      Result = Struct.new(:success?, :event, :alert, :notice, :redirect_url, keyword_init: true)

      HEROKU_HOST = "pickledpiratesracing-prod-e5b7e4ec2418.herokuapp.com"

      def self.call(event:, params:, request_host:, production:, image:, alt_image:)
        new(
          event: event,
          params: params,
          request_host: request_host,
          production: production,
          image: image,
          alt_image: alt_image
        ).call
      end

      def initialize(event:, params:, request_host:, production:, image:, alt_image:)
        @event = event
        @params = params
        @request_host = request_host
        @production = production
        @image = image
        @alt_image = alt_image
      end

      def call
        unless @event.update(@params)
          return Result.new(
            success?: false,
            event: @event,
            alert: @event.errors.full_messages.to_sentence.presence || "Event update failed"
          )
        end

        if require_heroku_upload?
          return Result.new(
            success?: true,
            event: @event,
            notice: "Event updated. Uploads must happen on the Heroku admin.",
            redirect_url: heroku_event_edit_url(@event)
          )
        end

        handle_image_uploads(@event)
        Result.new(success?: true, event: @event, notice: "Event updated")
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
    end
  end
end
