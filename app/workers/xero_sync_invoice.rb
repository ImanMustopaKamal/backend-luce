require "sidekiq/throttled"

class XeroSyncInvoice
  include Sidekiq::Worker
  include Sidekiq::Throttled::Job

  sidekiq_options(
    queue: 'default',
    retry: 1,
    backtrace: true
  )

  sidekiq_throttle concurrency: { limit: 1 }, threshold: { limit: 60, period: 60 }

  def perform(invoice_id = nil)
    raise ArgumentError, "Missing invoice ID" if invoice_id.nil?
    Rails.logger.info("[XeroSync] Starting for #{invoice_id}")
    invoice = Invoice.find(invoice_id)
    Xero::InvoiceSyncService.call(invoice)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("[XeroSync] Invoice not found: #{invoice_id}")
  rescue => e
    Rails.logger.error("[XeroSync] Error: #{e.message}")
    raise
  end
end
