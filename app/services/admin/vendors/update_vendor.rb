module Admin
  module Vendors
    class UpdateVendor
      Result = Struct.new(:success?, :vendor, keyword_init: true)

      def self.call(vendor:, params:)
        new(vendor: vendor, params: params).call
      end

      def initialize(vendor:, params:)
        @vendor = vendor
        @params = params
      end

      def call
        if @vendor.update(@params)
          Result.new(success?: true, vendor: @vendor)
        else
          Result.new(success?: false, vendor: @vendor)
        end
      end
    end
  end
end
