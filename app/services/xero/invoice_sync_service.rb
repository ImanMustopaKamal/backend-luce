module Xero
  class InvoiceSyncService
    def self.call(invoice)
      new(invoice).call
    end

    STATUS_MAP = {
      'NEW' => 'DRAFT',
      'CONFIRMED' => 'AUTHORISED',
      'CANCELLED' => 'VOIDED'
    }.freeze
    
    # PAYMENT_STATUSES = {
    #   'NEW' => 'UNPAID',
    #   'CONFIRMED' => 'UNDERPAID',
    #   'CANCELLED' => 'PAID'
    # }.freeze

    def initialize(invoice)
      @invoice = invoice
      @client = XeroClient.instance
    end

    def call
      # return if due_date_too_soon?
      
      payload = build_payload
      Rails.logger.info("Payload: #{payload.inspect}")
      
      if @invoice.xero_invoice_id.present?
        Rails.logger.info("Updating invoice with ID: #{@invoice.xero_invoice_id}")
        update_invoice(payload)
      else
        Rails.logger.info("Creating new invoice")
        create_invoice(payload)
      end
    end

    private

    def build_payload
      status = STATUS_MAP[@invoice.status]

      base_payload = {
        InvoiceNumber: @invoice.invoice_number,
        Status: status
      }

      return base_payload if status == 'VOIDED'

      base_payload.merge(
        Type: 'ACCREC',
        Contact: {
          Name: @invoice.client.name
        },
        Date: @invoice.created_at.to_date,
        DueDate: @invoice.due_date,
        CurrencyCode: 'SGD',
        LineAmountTypes: 'Exclusive',
        AmountDue: @invoice.paid_amount,
        LineItems: build_line_items
      )
    end

    def build_line_items
      @invoice.transactions.map do |txn|
        {
          Description: txn.description || "Work Item",
          Quantity: txn.quantity,
          UnitAmount: txn.unit_amount,
          AccountCode: "400",
          TaxType: "NONE"
        }
      end
    end

    def create_invoice(payload)
      response = @client.accounting_api.create_invoices('', invoices: [payload])
      handle_response(response)
    end

    def update_invoice(payload)
      Rails.logger.info("Updating invoice with ID: #{@invoice.xero_invoice_id}, payload: #{payload.inspect}")
      response = @client.accounting_api.update_invoice('', @invoice.xero_invoice_id, invoices: [payload])
      handle_response(response)
    end

    def handle_response(response)
      invoice_data = response.invoices&.first

      if invoice_data&.invoice_id
        @invoice.update_columns(
          xero_invoice_id: invoice_data.invoice_id,
          xero_synced_at: Time.current,
          # payment_status: PAYMENT_STATUSES[@invoice.status]
        )
      else
        Rails.logger.error("Failed to sync invoice with Xero: #{response.inspect}")
        raise "Xero invoice sync failed"
      end
    end

    def due_date_too_soon?
      @invoice.due_date < 5.days.from_now.to_date
    end

  end
end
