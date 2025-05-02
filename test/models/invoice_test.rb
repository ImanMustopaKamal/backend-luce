# == Schema Information
#
# Table name: invoices
#
#  id             :integer          not null, primary key
#  status         :string
#  payment_status :string
#  amount         :float
#  paid_amount    :float
#  issue_date     :date
#  due_date       :date
#  client_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase

  test 'invoice can be created and have its amount equal to the sum of transactions' do
    client = Client.create!(name: 'Test Client', email: 'makazone@gmail.com', phone: '1234567890')
    invoice = Invoice.create!(client: client, status: 'NEW', payment_status: 'UNPAID')
    invoice.update_amount

    assert_equal 0, invoice.amount
    assert_equal 'NEW', invoice.status
    assert_equal 'UNPAID', invoice.payment_status

    invoice.transactions.create!(quantity: 10, unit_amount: 1)
    invoice.transactions.create!(quantity: 20, unit_amount: 1)
    invoice.update_amount
    assert_equal 30, invoice.amount
  end

end
