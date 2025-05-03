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
  validates :due_date, presence: true

  scope :by_client_id, ->(client_id) { where(client_id: client_id) }
  scope :needs_sync, -> { where("due_date = ? AND (last_synced_at IS NULL OR updated_at > last_synced_at)", 5.days.from_now.to_date) }

  XERO_STATUS_MAP = {
    'NEW' => 'DRAFT',
    'CONFIRMED' => 'AUTHORISED',
    'CANCELLED' => 'VOID'
  }.freeze

  def cancel
    update(status: 'CANCELLED')
    XeroSyncJob.perform_later(id) if xero_id.present?
  end

  def confirm
    update(status: 'CONFIRMED')
    XeroSyncJob.perform_later(id) if xero_id.present?
  end

  def update_amount
    update(amount: compute_amount)
    XeroSyncJob.perform_later(id) if xero_id.present? # Trigger re-sync jika amount berubah
  end

  def compute_amount
    transactions.sum(&:amount)
  end

  def needs_sync?
    due_date == 5.days.from_now.to_date && (last_synced_at.nil? || updated_at > last_synced_at)
  end

end
