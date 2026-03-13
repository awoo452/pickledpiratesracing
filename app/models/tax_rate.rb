class TaxRate < ApplicationRecord
  before_validation :normalize_state

  validates :state, presence: true, uniqueness: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }

  def self.for_state(state)
    return BigDecimal("0") if state.blank?

    record = find_by(state: state.upcase)
    record&.rate&.to_d || BigDecimal("0")
  end

  private

  def normalize_state
    self.state = state.to_s.upcase
  end
end
