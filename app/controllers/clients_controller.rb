class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]
  before_action :set_xero_custom_connection

  # GET /clients or /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1 or /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @client.save!
          @client.sync_to_xero(@token_set.xero_tenant_id)
          format.html { redirect_to @client, notice: "Client was successfully created and synced to Xero." }
          format.json { render :show, status: :created, location: @client }
        end
      rescue => e
        Rails.logger.error("Error creating client: #{e.message}")
        format.html { render :new, alert: "Gagal membuat client: #{e.message}", status: :unprocessable_entity }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @client.update!(client_params)  # save changes to DB
  
          # Sync to Xero, if it fails it will raise an error and rollback
          @client.sync_to_xero('')
  
          format.html { redirect_to @client, notice: "Client was successfully updated and synced to Xero." }
          format.json { render :show, status: :ok, location: @client }
        end
      rescue => e
        Rails.logger.error("Gagal update client atau sync ke Xero: #{e.message}")
        format.html { render :edit, alert: "Gagal update client: #{e.message}", status: :unprocessable_entity }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    # if @client.xero_contact_id.present?
    #   begin
    #     # Delete contact from Xero
    #     XERO_CLIENT.accounting_api.delete_contact(
    #       '',
    #       @client.xero_contact_id
    #     )
    #   rescue XeroRuby::ApiError => e
    #     Rails.logger.error("Failed to delete contact from Xero: #{e.message}")
    #     redirect_to clients_url, alert: "Failed to delete contact from Xero: #{e.message}" and return
    #   end
    # end
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:name, :phone, :email)
    end

    def set_xero_custom_connection
      @token_set = XERO_CLIENT.get_client_credentials_token
    end 
end
