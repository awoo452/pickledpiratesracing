module Contact
  class SendMessage
    Result = Struct.new(:success?, :error, keyword_init: true)

    def self.call(email:, message:)
      new(email: email, message: message).call
    end

    def initialize(email:, message:)
      @email = email
      @message = message
    end

    def call
      if @email.blank? || @message.blank?
        return Result.new(success?: false, error: "Email and message are required")
      end

      ContactMailer.contact_email(@email, @message).deliver_later
      Result.new(success?: true)
    end
  end
end
