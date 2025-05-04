class AddInvoiceNumberToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :invoice_number, :string
    add_index :invoices, :invoice_number, unique: true
  end
end
