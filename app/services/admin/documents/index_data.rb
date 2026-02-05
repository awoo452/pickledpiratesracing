module Admin
  module Documents
    class IndexData
      Result = Struct.new(:documents, keyword_init: true)

      def self.call
        new.call
      end

      def call
        Result.new(documents: Document.order(created_at: :desc))
      end
    end
  end
end
