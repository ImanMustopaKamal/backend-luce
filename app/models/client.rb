# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string
#  phone      :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Client < ApplicationRecord
  has_many :invoices, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  def sync_to_xero(xero_tenant_id)
    contact = XeroRuby::Accounting::Contact.new(
      contact_id: xero_contact_id,
      name: name,
      email_address: email,
      phones: [
        XeroRuby::Accounting::Phone.new(
          phone_type: "MOBILE",
          phone_number: phone
        )
      ]
    )

    if xero_contact_id.present?
      contact.contact_id = xero_contact_id
      response = XERO_CLIENT.accounting_api.update_contact(xero_tenant_id, xero_contact_id, contact)
      if response.contacts&.first&.contact_id
        update!(xero_contact_id: response.contacts.first.contact_id)
      else
        Rails.logger.error("Failed to create Xero contact: #{response.inspect}")
        raise "Xero contact create failed"
      end
    else
      contacts = XeroRuby::Accounting::Contacts.new(contacts: [contact])
      response = XERO_CLIENT.accounting_api.create_contacts(xero_tenant_id, contacts)
      if response.contacts&.first&.contact_id
        update!(xero_contact_id: response.contacts.first.contact_id)
      else
        Rails.logger.error("Failed to create Xero contact: #{response.inspect}")
        raise "Xero contact create failed"
      end
    end
  rescue XeroRuby::ApiError => e
    Rails.logger.error("Xero API error: #{e.message}")
    raise "Xero API error"
  end

end
