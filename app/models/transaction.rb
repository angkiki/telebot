class Transaction < ApplicationRecord
  belongs_to :chat
  enum category: [ "/food", "/shopping", "/transport", "misc" ]
  validate :validates_amount

  def validates_amount
    errors.add(:amount, "Amount cannot be less than 0") if self.amount <= 0
  end
end
