# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                                  root GET    /                                                                                        welcome#index
#           client_invoice_transactions GET    /clients/:client_id/invoices/:invoice_id/transactions(.:format)                          transactions#index
#                                       POST   /clients/:client_id/invoices/:invoice_id/transactions(.:format)                          transactions#create
#        new_client_invoice_transaction GET    /clients/:client_id/invoices/:invoice_id/transactions/new(.:format)                      transactions#new
#       edit_client_invoice_transaction GET    /clients/:client_id/invoices/:invoice_id/transactions/:id/edit(.:format)                 transactions#edit
#            client_invoice_transaction GET    /clients/:client_id/invoices/:invoice_id/transactions/:id(.:format)                      transactions#show
#                                       PATCH  /clients/:client_id/invoices/:invoice_id/transactions/:id(.:format)                      transactions#update
#                                       PUT    /clients/:client_id/invoices/:invoice_id/transactions/:id(.:format)                      transactions#update
#                                       DELETE /clients/:client_id/invoices/:invoice_id/transactions/:id(.:format)                      transactions#destroy
#                client_invoice_confirm POST   /clients/:client_id/invoices/:invoice_id/confirm(.:format)                               invoices#confirm
#                 client_invoice_cancel POST   /clients/:client_id/invoices/:invoice_id/cancel(.:format)                                invoices#cancel
#          client_invoice_update_amount POST   /clients/:client_id/invoices/:invoice_id/update_amount(.:format)                         invoices#update_amount
#                       client_invoices GET    /clients/:client_id/invoices(.:format)                                                   invoices#index
#                                       POST   /clients/:client_id/invoices(.:format)                                                   invoices#create
#                    new_client_invoice GET    /clients/:client_id/invoices/new(.:format)                                               invoices#new
#                   edit_client_invoice GET    /clients/:client_id/invoices/:id/edit(.:format)                                          invoices#edit
#                        client_invoice GET    /clients/:client_id/invoices/:id(.:format)                                               invoices#show
#                                       PATCH  /clients/:client_id/invoices/:id(.:format)                                               invoices#update
#                                       PUT    /clients/:client_id/invoices/:id(.:format)                                               invoices#update
#                                       DELETE /clients/:client_id/invoices/:id(.:format)                                               invoices#destroy
#                               clients GET    /clients(.:format)                                                                       clients#index
#                                       POST   /clients(.:format)                                                                       clients#create
#                            new_client GET    /clients/new(.:format)                                                                   clients#new
#                           edit_client GET    /clients/:id/edit(.:format)                                                              clients#edit
#                                client GET    /clients/:id(.:format)                                                                   clients#show
#                                       PATCH  /clients/:id(.:format)                                                                   clients#update
#                                       PUT    /clients/:id(.:format)                                                                   clients#update
#                                       DELETE /clients/:id(.:format)                                                                   clients#destroy
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#   rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#health_check
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  root 'clients#index'
  resources :clients do
    resources :invoices do
      resources :transactions
      post 'confirm'
      post 'cancel'
      post 'update_amount'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
