require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "requires required fields" do
    expense = Expense.new

    assert_not expense.valid?
    assert_includes expense.errors[:description], "can't be blank"
    assert_includes expense.errors[:owed_to], "can't be blank"
    assert_includes expense.errors[:spent_on], "can't be blank"
    assert_includes expense.errors[:amount], "can't be blank"
  end

  test "outstanding scope" do
    outstanding = Expense.create!(
      description: "Fuel",
      owed_to: "Driver",
      spent_on: Date.current,
      amount: 20,
      reimbursed: false
    )
    Expense.create!(
      description: "Lodging",
      owed_to: "Crew",
      spent_on: Date.current,
      amount: 50,
      reimbursed: true
    )

    assert_includes Expense.outstanding, outstanding
  end
end
