module EnhancementRequests
  class CreateRequest
    Result = Struct.new(:success?, :error, keyword_init: true)

    def self.call(email:, message:)
      new(email: email, message: message).call
    end

    def initialize(email:, message:)
      @email = email
      @message = message
    end

    def call
      if @message.blank?
        return Result.new(success?: false, error: "Request message is required")
      end

      EnhancementRequest.create(email: @email, message: @message)
      Result.new(success?: true)
    end
  end
end
