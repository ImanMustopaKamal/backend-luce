require 'xero-ruby'

XERO_CLIENT = XeroRuby::ApiClient.new(credentials: {
  client_id: ENV['XERO_CLIENT_ID'],
  client_secret: ENV['XERO_CLIENT_SECRET'],
  grant_type: 'client_credentials'
})
