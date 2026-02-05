module Admin
  module Documents
    class UpdateDocument
      Result = Struct.new(:success?, :document, :error, keyword_init: true)

      def self.call(document:, params:)
        new(document: document, params: params).call
      end

      def initialize(document:, params:)
        @document = document
        @params = params
      end

      def call
        if @document.update(@params)
          Result.new(success?: true, document: @document)
        else
          Result.new(
            success?: false,
            document: @document,
            error: @document.errors.full_messages.to_sentence.presence || "Document update failed"
          )
        end
      end
    end
  end
end
