class AddXeroInvoiceIdToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :xero_invoice_id, :string
  end
end
