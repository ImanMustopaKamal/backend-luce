class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :status
      t.string :payment_status
      t.float :amount
      t.float :paid_amount
      t.date :issue_date
      t.date :due_date
      t.belongs_to :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
