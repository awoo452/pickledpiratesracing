module Admin
  module Expenses
    class UpdateExpense
      Result = Struct.new(:success?, :expense, keyword_init: true)

      def self.call(expense:, params:)
        new(expense: expense, params: params).call
      end

      def initialize(expense:, params:)
        @expense = expense
        @params = params
      end

      def call
        if @expense.update(@params)
          Result.new(success?: true, expense: @expense)
        else
          Result.new(success?: false, expense: @expense)
        end
      end
    end
  end
end
