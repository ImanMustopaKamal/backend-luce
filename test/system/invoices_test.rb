require "application_system_test_case"

class InvoicesTest < ApplicationSystemTestCase
  setup do
    @invoice = invoices(:one)
  end

  test "visiting the index" do
    visit client_invoices_url(client_id: @invoice.client_id)
    assert_selector "h1", text: "Invoices"
  end

  test "creating a Invoice" do
    visit client_invoices_url(client_id: @invoice.client_id)
    click_on "New Invoice"

    fill_in "Amount", with: @invoice.amount
    fill_in "Due date", with: @invoice.due_date
    fill_in "Issue date", with: @invoice.issue_date
    fill_in "Paid amount", with: @invoice.paid_amount
    fill_in "Payment status", with: @invoice.payment_status
    fill_in "Status", with: @invoice.status
    click_on "Create Invoice"

    assert_text "Invoice was successfully created"
  end

  test "updating a Invoice" do
    visit client_invoices_path(client_id: @invoice.client_id)
    click_on "Edit", match: :first

    fill_in "Amount", with: @invoice.amount
    fill_in "invoice_due_date", with: '2018-01-01'
    fill_in "Issue date", with: @invoice.issue_date
    fill_in "Paid amount", with: @invoice.paid_amount
    fill_in "Payment status", with: @invoice.payment_status
    fill_in "Status", with: @invoice.status
    click_on "Update Invoice"

    assert_text "Invoice was successfully updated"
  end

  test "destroying a Invoice" do
    visit client_invoices_url(client_id: @invoice.client_id)
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invoice was successfully destroyed"
  end
end
