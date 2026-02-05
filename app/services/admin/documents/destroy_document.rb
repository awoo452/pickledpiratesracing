module Admin
  module Documents
    class DestroyDocument
      Result = Struct.new(:success?, :document, keyword_init: true)

      def self.call(document:)
        new(document: document).call
      end

      def initialize(document:)
        @document = document
      end

      def call
        @document.destroy
        Result.new(success?: true, document: @document)
      end
    end
  end
end
