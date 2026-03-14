class Expense < ApplicationRecord
  scope :outstanding, -> { where(reimbursed: false) }

  validates :description, presence: true
  validates :owed_to, presence: true
  validates :spent_on, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
