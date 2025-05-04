class XeroClient
  def self.instance
    @instance ||= begin
      client = XeroRuby::ApiClient.new(
        credentials: {
          client_id: ENV['XERO_CLIENT_ID'],
          client_secret: ENV['XERO_CLIENT_SECRET'],
          grant_type: 'client_credentials'
        }
      )

      client.set_token_set(client.get_client_credentials_token)
      client
    end
  end
end