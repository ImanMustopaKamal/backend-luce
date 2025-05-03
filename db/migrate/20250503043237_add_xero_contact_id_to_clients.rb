class AddXeroContactIdToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :xero_contact_id, :string
  end
end
