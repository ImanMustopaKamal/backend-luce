require "sidekiq/throttled"

class XeroInvoiceSyncJob < ApplicationJob
  queue_as :default

  include Sidekiq::Throttled::Job

  sidekiq_throttle({
    concurrency: { limit: 1 },              # Hanya 1 job jalan sekaligus (opsional)
    threshold:   { limit: 60, period: 60 }  # Maks 60 call/menit
  })

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    Xero::InvoiceSyncService.new(invoice).call
  rescue => e
    Rails.logger.error("Xero sync failed for invoice #{invoice_id}: #{e.message}")
  end
end
