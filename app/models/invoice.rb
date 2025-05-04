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
class Invoice < ApplicationRecord
  STATUSES = %w[NEW CONFIRMED CANCELLED].freeze
  PAYMENT_STATUSES = %w[PAID UNPAID UNDERPAID].freeze

  belongs_to :client
  has_many :transactions, dependent: :destroy

  validates :status, presence: true, inclusion: STATUSES
  validates :payment_status, presence: true, inclusion: PAYMENT_STATUSES
  validate :zero_transaction

  scope :by_client_id, ->(client_id) { where(client_id: client_id) }

  # before_validation :generate_invoice_number, on: :create

  # def self.next_sequence_number
  #   maximum("CAST(SUBSTRING(invoice_number FROM '[0-9]+') AS INTEGER)") || 1000
  # end

  # def to_param
  #   invoice_number
  # end

  def cancel
    update(status: 'CANCELLED', payment_status: 'PAID')
    # sync_to_xero
  end

  def confirm
    if transactions.blank?
      errors.add(:base, "Invoice cannot be confirmed because it has no transactions.")
      return false
    end
    update(status: 'CONFIRMED')
    sync_to_xero
  end

  def update_amount
    update(amount: compute_amount)
    sync_to_xero
  end

  def compute_amount
    if transactions.empty?
      0
    else
      transactions.sum(&:amount)
    end
  end

  def sync_to_xero
    Rails.logger.info("Syncing invoice by id ##{self.id} to Xero")
    XeroSyncInvoice.perform_async(self.id)
  end

  private

  # def generate_invoice_number
  #   return if invoice_number.present? || !new_record?

  #   date_prefix = Date.current.strftime('%Y%m')
  #   seq = self.class.next_sequence_number + 1
  #   self.invoice_number = "INV-#{date_prefix}-#{seq.to_s.rjust(4, '0')}"
  # end

  def zero_transaction
    # Check if the invoice is being cancelled and if the total transaction amount is zero
    if status_changed? && status == "CANCELLED" && transactions.sum(&:amount).zero?
      errors.add(:status, "cannot be set to CANCELLED because total transaction amount is zero.")
    end
  end

end
