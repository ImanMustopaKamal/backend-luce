# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  unit_amount :float
#  quantity    :integer
#  date        :date
#  description :string
#  invoice_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :invoice

  validates :unit_amount, :quantity, numericality: { greater_than: 0 }
  scope :by_invoice_id, ->(invoice_id) { where(invoice_id: invoice_id) }

  def amount
    unit_amount * quantity
  end

  after_save :trigger_invoice_update
  after_destroy :trigger_invoice_update

  private

  def trigger_invoice_update
    invoice.update_amount
  end
end
