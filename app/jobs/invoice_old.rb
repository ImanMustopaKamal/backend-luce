class InvoiceOld < ApplicationJob
  queue_as :default

  BATCH_SIZE = 100
  SYNC_BUFFER_DAYS = 5

  def perform
    due_limit = Date.today + SYNC_BUFFER_DAYS

    invoices = Invoice
      .where("due_date <= ?", due_limit)
      .where("xero_synced_at IS NULL OR updated_at > xero_synced_at")

    invoices.find_in_batches(batch_size: BATCH_SIZE) do |batch|
      batch.each do |invoice|
        begin
          Rails.logger.info("Enqueuing invoice ##{invoice.id} for Xero sync")
          # XeroInvoiceSyncJob.perform_later(invoice.id)
        rescue => e
          Rails.logger.error("Failed to enqueue invoice ##{invoice.id}: #{e.message}")
        end
      end
    end
  end
end
