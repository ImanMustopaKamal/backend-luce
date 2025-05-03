# app/services/xero_invoice_sync.rb
class XeroInvoiceSync
  # Status mapping sesuai requirement
  STATUS_MAPPING = {
    'NEW'       => 'DRAFT',
    'CONFIRMED' => 'AUTHORISED',
    'CANCELLED' => 'VOID'
  }.freeze

  # Xero API rate limit (60 requests/minute)
  API_LIMIT_DELAY = 1.second

  def initialize(invoice)
    @invoice = invoice
    @client = invoice.client
    @logger = Rails.logger
  end

  def call
    return log_skip("Invoice #{@invoice.id} tidak memenuhi kondisi sync") unless should_sync?

    begin
      if @invoice.xero_id.nil?
        create_xero_invoice
      else
        update_xero_invoice
      end
      
      @invoice.update!(last_synced_at: Time.current)
      log_success
    rescue XeroRuby::ApiError => e
      log_error("Xero API Error: #{e.message}")
      false
    rescue ActiveRecord::RecordInvalid => e
      log_error("Database Error: #{e.message}")
      false
    ensure
      sleep API_LIMIT_DELAY if defined?(xero_client) # Jaga API rate limit
    end
  end

  private

  def should_sync?
    # Sync jika:
    # 1. 5 hari sebelum due date ATAU
    # 2. Invoice sudah pernah sync tapi ada perubahan
    (@invoice.due_date == 5.days.from_now.to_date) ||
    (@invoice.xero_id.present? && @invoice.updated_at > @invoice.last_synced_at)
  end

  def xero_client
    @xero_client ||= XeroRuby::ApiClient.new(
      credentials: {
        client_id: ENV['XERO_CLIENT_ID'],
        client_secret: ENV['XERO_CLIENT_SECRET'],
        tenant_id: ENV['XERO_TENANT_ID']
      },
      timeout: 30 # seconds
    )
  end

  def create_xero_invoice
    @logger.info "Creating Xero invoice for Invoice #{@invoice.id}"
    response = xero_client.accounting_api.create_invoices(
      xero_tenant_id: ENV['XERO_TENANT_ID'],
      invoices: [build_xero_invoice]
    )
    
    @invoice.update!(xero_id: response.invoices.first.invoice_id)
  end

  def update_xero_invoice
    @logger.info "Updating Xero invoice #{@invoice.xero_id} for Invoice #{@invoice.id}"
    xero_client.accounting_api.update_invoice(
      xero_tenant_id: ENV['XERO_TENANT_ID'],
      invoice_id: @invoice.xero_id,
      invoices: [build_xero_invoice]
    )
  end

  def build_xero_invoice
    {
      type: 'ACCREC', # Account Receivable
      contact: { contact_id: @client.xero_contact_id },
      date: @invoice.created_at.to_date,
      due_date: @invoice.due_date,
      status: STATUS_MAPPING[@invoice.status],
      currency_code: 'SGD',
      reference: "INV-#{@invoice.id}",
      line_items: build_line_items,
      url: "#{ENV['APP_HOST']}/invoices/#{@invoice.id}" # Optional: link ke aplikasi
    }
  end

  def build_line_items
    @invoice.transactions.map do |transaction|
      {
        description: transaction.description.presence || "Item #{transaction.id}",
        quantity: transaction.quantity,
        unit_amount: transaction.unit_amount.to_f / 100, # Convert cents to dollars
        account_code: ENV['XERO_SALES_ACCOUNT_CODE'] # Default account code
      }
    end
  end

  def log_skip(message)
    @logger.info "[XeroSync] Skip: #{message}"
    false
  end

  def log_success
    @logger.info "[XeroSync] Success: Invoice #{@invoice.id} synced to Xero #{@invoice.xero_id}"
    true
  end

  def log_error(message)
    @logger.error "[XeroSync] Error: #{message}"
    Rollbar.error(message) if defined?(Rollbar) # Optional: error tracking
  end
end