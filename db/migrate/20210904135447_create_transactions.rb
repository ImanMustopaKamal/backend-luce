class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :unit_amount
      t.integer :quantity
      t.date :date
      t.string :description
      t.belongs_to :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
