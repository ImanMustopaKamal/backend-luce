# Luce Hiring Assignment

### ❗This test is confidential. Please, avoid publishing this test or the solution on the internet ❗

## Overview

The app manages invoices for clients.
Each client can have multiple invoices. Each invoice can have multiple transactions. The invoice amount to be paid is derived from the transactions attached to an invoice.

- Invoices are generated automatically via a cron job that is run every 7 days. (rake task: generate_invoices)
- Invoice can have 3 statuses: NEW, CONFIRMED, & CANCELLED
- Invoice can also store the value of paid_amount along with payment_status as UNPAID, UNDERPAID, PAID. But the app currently does have a mechanism to apply a payment or keep track of it.
- Invoice amount value is the sum of amounts for each attached transaction. Although the sync between invoice.amount and its trasactions is not real time. The `invoice.amount` value has to be updated explicitly whenever its trasactions are modified.
- Relevant methods/controller actions on Invoice:
  - confirm
  - cancel
  - compute_amount
- The transaction amount is calculated as: unit_value \* quantity
- Use the `seeds.rb` file to create some clients.

# Development

Ruby version: 3.0.0

Rails version: 7.0.4

Node version: 15.14

## The UI

- There is some UI which helps manage all the data.

## Running locally

- Make sure you have correct versions of ruby, node and bundler installed.
- Run `make setup` to configure the project
- After that you can run `make start`
- You should be able to open `http://localhost:3000` and play around with the app

You can see `Makefile` and copy-paste commands from it manually too.

At this point consider initiating a new `git` repository and making an initial commit. Please, as you go about implementing the exercise, commit to git as you would normally do as if you were working on a PR.

## Xero Integration

This application includes a one-way synchronization feature with [Xero](https://www.xero.com/) to keep invoice data up to date. The sync process is implemented using Xero's Custom Connection and Demo Company setup.

### Key Behaviors

- **Sync Trigger:** Invoices are automatically synced to Xero after a transaction is created or updated.
- **Sync Timing Constraint:** Invoices are only eligible for sync if their due date is at least 5 days away (as required by business logic).
- **Status Mapping:**
  - `NEW` → `DRAFT` in Xero
  - `CONFIRMED` → `AUTHORISED` in Xero (indicates awaiting payment)
  - `CANCELLED` → `VOID` in Xero
- **Invoice Amount Calculation:** Invoice amounts are recalculated and updated in Xero whenever new transactions are added or modified.
- **Currency:** All invoices are created in SGD (Singapore Dollars).
- **Rate Limiting:** The system respects Xero API rate limits (60 calls per minute, 5,000 per day) and handles large batches (up to 15,000 invoices) using throttling and background processing.

---
## Environment Variables

Create a `.env` file in the root directory of the project with the following content:

```env
XERO_CLIENT_ID=your_xero_client_id
XERO_CLIENT_SECRET=your_xero_client_secret
XERO_REDIRECT_URI=your_redirect_uri
XERO_SCOPES=accounting.transactions offline_access
```

## Testing Xero Sync (Manual Steps)

1. Run the application and background worker using:
   ```sh
   make setup
   make dev
   ```