module Admin
  module Vendors
    class CreateVendor
      Result = Struct.new(:success?, :vendor, keyword_init: true)

      def self.call(params:)
        new(params: params).call
      end

      def initialize(params:)
        @params = params
      end

      def call
        vendor = Vendor.new(@params)
        if vendor.save
          Result.new(success?: true, vendor: vendor)
        else
          Result.new(success?: false, vendor: vendor)
        end
      end
    end
  end
end
