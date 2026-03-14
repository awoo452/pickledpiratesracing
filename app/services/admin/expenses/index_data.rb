module Admin
  module Expenses
    class IndexData
      Result = Struct.new(
        :expenses,
        :total_spent,
        :total_outstanding,
        :outstanding_by_person,
        keyword_init: true
      )

      def self.call
        new.call
      end

      def call
        expenses = Expense.order(spent_on: :desc, created_at: :desc)
        outstanding = Expense.outstanding

        Result.new(
          expenses: expenses,
          total_spent: Expense.sum(:amount),
          total_outstanding: outstanding.sum(:amount),
          outstanding_by_person: outstanding.group(:owed_to).sum(:amount)
        )
      end
    end
  end
end
