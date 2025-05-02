class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy confirm cancel update_amount ]
  before_action :set_client

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
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to client_invoices_url(id: @client.id), notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
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
end
