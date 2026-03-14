class Admin::ExpensesController < Admin::BaseController
  before_action :set_expense, only: [ :edit, :update, :destroy ]

  def index
    data = Admin::Expenses::IndexData.call
    @expenses = data.expenses
    @total_spent = data.total_spent
    @total_outstanding = data.total_outstanding
    @outstanding_by_person = data.outstanding_by_person
  end

  def new
    @expense = Expense.new(spent_on: Date.current)
  end

  def create
    result = Admin::Expenses::CreateExpense.call(params: expense_params)
    @expense = result.expense

    if result.success?
      redirect_to admin_expenses_path, notice: "Expense added"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = Admin::Expenses::UpdateExpense.call(expense: @expense, params: expense_params)

    if result.success?
      redirect_to admin_expenses_path, notice: "Expense updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Admin::Expenses::DestroyExpense.call(expense: @expense)
    redirect_to admin_expenses_path, notice: "Expense deleted"
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.fetch(:expense, {}).permit(
      :description,
      :owed_to,
      :amount,
      :spent_on,
      :reimbursed,
      :notes
    )
  end
end
