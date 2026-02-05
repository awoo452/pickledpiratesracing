module Admin
  module ProductVariants
    class UpdateVariant
      Result = Struct.new(:success?, :variant, keyword_init: true)

      def self.call(variant:, params:)
        new(variant: variant, params: params).call
      end

      def initialize(variant:, params:)
        @variant = variant
        @params = params
      end

      def call
        if @variant.update(@params)
          Result.new(success?: true, variant: @variant)
        else
          Result.new(success?: false, variant: @variant)
        end
      end
    end
  end
end
