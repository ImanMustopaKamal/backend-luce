class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy confirm cancel update_amount ]
  before_action :set_client
  before_action :set_xero_client

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.by_client_id(@client.id)
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @form_path = client_invoices_path(@client)
  end

  # GET /invoices/1/edit
  def edit
    @form_path = client_invoice_path(id: @invoice.id)
  end

  def confirm
    @invoice.confirm
    redirect_to client_invoice_url(id: @invoice.id), notice: "Invoice was successfully confirmed."
  end

  def cancel
    @invoice.cancel
    redirect_to client_invoice_url(id: @invoice.id), notice: "Invoice was successfully cancelled."
  end

  def update_amount
    @invoice.update_amount
    redirect_to client_invoice_url(id: @invoice.id), notice: "Invoice amount was successfully updated."
  end

  # POST /invoices or /invoices.json
  def create
    xero_tenant_id = ''
    invoice = XeroRuby::Accounting::Invoice.new(
      type: "ACCREC",
      contact: XeroRuby::Accounting::Contact.new(
        name: "John Doe" # Atau contact_id: "uuid-dari-xero"
      ),
      line_items: [
        XeroRuby::Accounting::LineItem.new(
          description: "Consulting Service",
          quantity: 1.0,
          unit_amount: 100.0,
          account_code: "200" # Sesuaikan dengan kode akun di Xero
        )
      ],
      date: Date.today,
      due_date: Date.today + 30,
      status: "DRAFT", # atau "AUTHORISED"
      line_amount_types: "Exclusive"
    ) 

    invoices = {  
      invoices: [invoice]
    }
    
    begin
      response = @accounting_api.create_invoices(xero_tenant_id, invoices)
      Rails.logger.info "Xero response: #{response.to_hash}"
      # return response
    rescue XeroRuby::ApiError => e
      puts "Exception when calling create_invoices: #{e}"
    end
    # @invoice = Invoice.new(invoice_params)

    # respond_to do |format|
    #   if @invoice.save
    #     format.html { redirect_to client_invoices_url(id: @client.id), notice: "Invoice was successfully created." }
    #     format.json { render :show, status: :created, location: @invoice }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @invoice.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to client_invoices_url(id: @client.id), notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to client_invoices_url(id: @client.id), notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id] || params[:invoice_id])
    end

    def set_client
      @client = Client.find(params[:client_id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:status, :payment_status, :amount, :paid_amount, :issue_date, :due_date, :client_id)
    end

    def set_xero_client
      @token_set = XERO_CLIENT.get_client_credentials_token
      # @tenant_id = XERO_CLIENT.connections.first.tenant_id
      @accounting_api = XERO_CLIENT.accounting_api
    end
end
