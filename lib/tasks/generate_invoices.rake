task generate_invoices: :environment do
  # generates dummy data for invoices with transactions
  generate_invoices
end

def generate_invoices
  Client.all.each do |client|
    5.times do
      invoice = Invoice.create(new_invoice_params(client))
      3.times do
        transaction = Transaction.create(new_transaction_params(invoice))
      end
      invoice.update_amount
    end
  end
end

def new_invoice_params(client)
  {
    client: client,
    status: 'NEW',
    payment_status: 'UNPAID',
    amount: 0,
    paid_amount: 0,
    issue_date: Date.today,
    due_date: Date.today + 7.days
  }
end

def new_transaction_params(invoice)
  date = Date.today - rand(6).days
  quantity = rand(9) + 1
  {
    invoice: invoice,
    unit_amount: rand(100) + 1,
    quantity: quantity,
    date: date,
    description: "#{quantity} hours service fee for #{date.to_s}"
  }
end
