class Transaction < ApplicationRecord
  belongs_to :chat
  enum category: [ "/food", "/shopping", "/transport", "/misc" ]
  validate :validates_amount

  def validates_amount
    errors.add(:amount, "Amount cannot be less than 0") if self.amount <= 0
  end

  # method for displaying custom classes for use in home#show_user.html.erb
  def display_class
    return "user-tr__red" if self.amount >= 50
    return "user-tr__orange" if self.amount >= 25
    return "user-tr__green" if self.amount >= 10

    nil
  end
end
