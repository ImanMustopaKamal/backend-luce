json.extract! invoice, :id, :status, :payment_status, :amount, :paid_amount, :issue_date, :due_date, :client_id, :created_at, :updated_at
json.url client_invoice_url(invoice, format: :json)
