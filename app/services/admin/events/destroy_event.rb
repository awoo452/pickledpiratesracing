module Admin
  module Events
    class DestroyEvent
      Result = Struct.new(:success?, :event, keyword_init: true)

      def self.call(event:)
        new(event: event).call
      end

      def initialize(event:)
        @event = event
      end

      def call
        @event.destroy
        Result.new(success?: true, event: @event)
      end
    end
  end
end
