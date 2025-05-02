json.extract! transaction, :id, :unit_amount, :quantity, :date, :description, :invoice_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
