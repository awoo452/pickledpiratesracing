# Pickled Pirates Racing

Pickled Pirates Racing site with a storefront, events, videos, swap meet, and admin tools.

## Features

- Public pages: Home, About, Products, Videos.
- Requires sign-in: Events, Swap Meet (Parts), Account, and all admin screens.
- Admin access: User must have `users.admin = true`.

### Storefront Workflow

- Products require at least one active variant (with stock > 0, `price_hidden = false`) to be purchasable.
- Pricing auto-calculates from vendor costs, handling fee, and margin.
- Price fields are not editable in admin; each active variant must have a vendor unit cost.
- If price is hidden, "Coming Soon" is shown and checkout is disabled.

### Product Configuration

1. Create a vendor first (Admin → Vendors) with contact details.
2. Create a product, then add variants (size, color, etc.).
3. Add vendor pricing links for each variant with unit cost (pricing will not publish without these).
4. Set the product margin (%) and handling fee; prices auto-calculate as `unit_cost + handling` at target margin.
5. Keep variants active with stock > 0 to display in the storefront.

### Cart & Checkout

- Checkout is cart-based. Product pages add items to the cart. PayPal buttons are on the Cart page.
- Cart validation blocks checkout if variants are inactive, out of stock, price hidden, or pricing is pending.
- Shipping: $5 for the first cart item + $4 per additional item.
- Bulky items: +$5 each.
- Tax: Uses `tax_rates` (state defaults to WA).
- Orders store: subtotal, shipping, bulky fee, tax, and total.

### Admin Uploads (Heroku)

- Image uploads for products and events must occur on the Heroku admin host in production.
- On Heroku: product edit page is uploads-only; edit product details on the main admin domain.
- Event details can be edited on any host, but image uploads require Heroku.

### S3 Images & Image Proxy

- Product images: `products/<slug>/main.<ext>`, `products/<slug>/alt.<ext>`
- Event images: `events/<id>/main.<ext>`, `events/<id>/alt.<ext>`
- If `IMAGE_PROXY_BASE_URL` and `IMAGE_PROXY_SIGNING_KEY` are set, thumbnail URLs use the image proxy; otherwise, S3 presigned URLs are used (AWS credentials required).

### Inventory

- Inventory is tracked per product variant.
- Update stock and active status from the admin variant edit screen.

### Vendor Management

- Vendors store supplier contact info and are used for pricing links.
- Vendor pricing links connect vendors to variants, specifying unit cost, MSRP, lead time, and notes.

### Admin Ledger (Expenses)

- Admin → Ledger tracks out-of-pocket spend and who the business owes.
- Each entry records: description, owed to, amount, spent-on date, reimbursed flag, and notes.

### Docs

- Docs are managed in Admin → Docs.

### Payments & Inventory

- PayPal create/capture calls create `Order` and `OrderItem` records, and decrement variant stock.

### Notes

- In production, admin uploads redirect to the Heroku admin host defined in the admin services.

## Setup

1. `bundle install`
2. `bin/rails db:prepare` (or `bin/setup`)

Optional seed data:
- `bin/rails db:seed`

### Environment Variables

Set the following environment variables as needed:

- `PAYPAL_CLIENT_ID` (required to render PayPal buttons)
- `PAYPAL_SECRET`
- `PAYPAL_ENV` (defaults to `sandbox`, use `live` for production)
- `AWS_REGION` or `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_BUCKET`
- `IMAGE_PROXY_BASE_URL`
- `IMAGE_PROXY_SIGNING_KEY`
- `CONTACT_EMAIL` (defaults to `pickledpiratescc@gmail.com`)
- `SES_SMTP_USERNAME` (for production mail)
- `SES_SMTP_PASSWORD` (for production mail)
- `DATABASE_URL` (for production database)
- `RAILS_LOG_LEVEL`
- `RAILS_MAX_THREADS`
- `PORT`
- `JOB_CONCURRENCY`

## Run

1. `bin/dev`

## Tests

1. `bin/rails test`
2. `bin/rails test:system`

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md) for notable changes.
