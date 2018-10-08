class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.text :description
      t.references :chat, foreign_key: true
      t.integer :category

      t.timestamps
    end
  end
end
