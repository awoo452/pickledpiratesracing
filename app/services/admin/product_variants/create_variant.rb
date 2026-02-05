module Admin
  module ProductVariants
    class CreateVariant
      Result = Struct.new(:success?, :variant, keyword_init: true)

      def self.call(params:)
        new(params: params).call
      end

      def initialize(params:)
        @params = params
      end

      def call
        variant = ProductVariant.new(@params)
        if variant.save
          Result.new(success?: true, variant: variant)
        else
          Result.new(success?: false, variant: variant)
        end
      end
    end
  end
end
