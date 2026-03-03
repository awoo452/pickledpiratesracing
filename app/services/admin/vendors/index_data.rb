module Admin
  module Vendors
    class IndexData
      Result = Struct.new(:vendors, keyword_init: true)

      def self.call
        new.call
      end

      def call
        Result.new(vendors: Vendor.order(:name))
      end
    end
  end
end
