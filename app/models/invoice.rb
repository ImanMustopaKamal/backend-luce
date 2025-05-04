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
  validates :invoice_number, presence: true, uniqueness: true

  before_validation :generate_invoice_number, on: :create

  after_commit :sync_to_xero, on: [:update]

  scope :by_client_id, ->(client_id) { where(client_id: client_id) }

  def cancel
    unless status == 'CONFIRMED'
      errors.add(:base, "Invoice can only be cancelled if it is in CONFIRMED status.")
      return false
    end
    
    update(status: 'CANCELLED')
    sync_to_xero
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

  def generate_invoice_number
    return if invoice_number.present?

    date_part = Date.current.strftime('%Y%m%d')
    seq = Invoice.where("invoice_number LIKE ?", "INV-#{date_part}-%").count + 1
    self.invoice_number = "INV-#{date_part}-#{seq.to_s.rjust(4, '0')}"
  end

  def zero_transaction
    # Check if the invoice is being cancelled and if the total transaction amount is zero
    if status_changed? && status == "CANCELLED" && transactions.sum(&:amount).zero?
      errors.add(:status, "cannot be set to CANCELLED because total transaction amount is zero.")
    end
  end

end
