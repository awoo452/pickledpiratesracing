module Admin
  module Expenses
    class DestroyExpense
      def self.call(expense:)
        new(expense: expense).call
      end

      def initialize(expense:)
        @expense = expense
      end

      def call
        @expense.destroy
      end
    end
  end
end
