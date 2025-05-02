require "application_system_test_case"

class TransactionsTest < ApplicationSystemTestCase
  setup do
    @transaction = transactions(:one)
  end

  test "visiting the index" do
    visit client_invoice_transactions_url(invoice_id: @transaction.invoice_id, 
      client_id: @transaction.invoice.client_id)
    assert_selector "h1", text: "Transactions"
  end

  test "creating a Transaction" do
    visit client_invoice_transactions_url(invoice_id: @transaction.invoice_id, 
      client_id: @transaction.invoice.client_id)
    click_on "New Transaction"

    fill_in "Description", with: @transaction.description
    fill_in "Invoice", with: @transaction.invoice_id
    fill_in "Quantity", with: @transaction.quantity
    fill_in "Unit amount", with: @transaction.unit_amount
    # fill_in "Date", with: @transaction.date

    click_on "Create Transaction"

    assert_text "Transaction was successfully created"
  end

  test "updating a Transaction" do
    visit client_invoice_transactions_url(invoice_id: @transaction.invoice_id, 
      client_id: @transaction.invoice.client_id)

    click_on "Edit", match: :first

    # fill_in "Date", with: @transaction.date
    fill_in "Description", with: @transaction.description
    fill_in "Invoice", with: @transaction.invoice_id
    fill_in "Quantity", with: @transaction.quantity
    fill_in "Unit amount", with: @transaction.unit_amount
    click_on "Update Transaction"

    assert_text "Transaction was successfully updated"
  end

  test "destroying a Transaction" do
    visit client_invoice_transactions_url(invoice_id: @transaction.invoice_id, 
      client_id: @transaction.invoice.client_id)

    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction was successfully destroyed"
  end
end
