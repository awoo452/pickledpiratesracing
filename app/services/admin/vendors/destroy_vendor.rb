module Admin
  module Vendors
    class DestroyVendor
      def self.call(vendor:)
        new(vendor: vendor).call
      end

      def initialize(vendor:)
        @vendor = vendor
      end

      def call
        @vendor.destroy
      end
    end
  end
end
