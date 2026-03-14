module Admin
  module Expenses
    class CreateExpense
      Result = Struct.new(:success?, :expense, keyword_init: true)

      def self.call(params:)
        new(params: params).call
      end

      def initialize(params:)
        @params = params
      end

      def call
        expense = Expense.new(@params)
        if expense.save
          Result.new(success?: true, expense: expense)
        else
          Result.new(success?: false, expense: expense)
        end
      end
    end
  end
end
