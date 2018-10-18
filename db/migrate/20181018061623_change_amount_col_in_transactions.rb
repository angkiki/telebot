class ChangeAmountColInTransactions < ActiveRecord::Migration[5.2]
  def change
    change_column :transactions, :amount, :decimal, precision: 8, scale: 2
  end
end
