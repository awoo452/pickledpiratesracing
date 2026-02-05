module Admin
  module Documents
    class CreateDocument
      Result = Struct.new(:success?, :document, :error, keyword_init: true)

      def self.call(params:)
        new(params: params).call
      end

      def initialize(params:)
        @params = params
      end

      def call
        document = Document.new(@params)
        if document.save
          Result.new(success?: true, document: document)
        else
          Result.new(
            success?: false,
            document: document,
            error: document.errors.full_messages.to_sentence.presence || "Document creation failed"
          )
        end
      end
    end
  end
end
