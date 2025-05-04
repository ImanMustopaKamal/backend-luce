class AddXeroSyncFieldsToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :xero_synced_at, :datetime
  end
end
