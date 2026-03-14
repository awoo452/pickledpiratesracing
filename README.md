# Pickled Pirates Racing

Pickled Pirates Racing site with a storefront, events, videos, swap meet, and admin tools.

## Stack
- Ruby 4.0.1
- Rails 8.1.2
- PostgreSQL

## Setup
1. `bundle install`
2. `bin/rails db:prepare` (or `bin/setup`)
3. `bin/dev`

## Seed data (optional)
- `bin/rails db:seed`

## Tests
- `bin/rails test`
- `bin/rails test:system`

## Environment variables
- `PAYPAL_CLIENT_ID` (required to render PayPal buttons)
- `PAYPAL_SECRET`
- `PAYPAL_ENV` (defaults to `sandbox`, set to `live` for production)
- `AWS_REGION` or `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_BUCKET`
- `IMAGE_PROXY_BASE_URL`
- `IMAGE_PROXY_SIGNING_KEY`
- `CONTACT_EMAIL` (defaults to `pickledpiratescc@gmail.com`)
- `SES_SMTP_USERNAME` (production mail)
- `SES_SMTP_PASSWORD` (production mail)
- `DATABASE_URL` (production)
- `RAILS_LOG_LEVEL`
- `RAILS_MAX_THREADS`
- `PORT`
- `JOB_CONCURRENCY`

## Public vs. signed-in
- Public pages: Home, About, Products, Videos.
- Requires sign-in: Events, Swap Meet (Parts), Account, and all admin screens.
- Admin access requires `users.admin = true`.

## Storefront workflow
- Products must have at least one active variant with stock > 0 and `price_hidden = false` to be purchasable.
- Pricing is auto-calculated from vendor costs + handling fee + margin.
- Price fields are not editable in admin. Each active variant must have vendor pricing (unit cost).
- Price hidden shows Coming Soon and hides checkout.

## Product configuration
- Create the vendor first (Admin → Vendors) with contact details.
- Create a product, then add variants (size/color/etc.).
- Add vendor pricing links for each variant with unit cost; pricing will not publish without vendor costs.
- Set product margin % and handling fee; prices auto-calculate from `unit_cost + handling` at the target margin.
- Keep variants active with stock > 0 to show in the storefront.

## Cart + checkout
- Checkout is cart-based. Product pages add to cart; PayPal buttons live on the Cart page.
- Cart validation blocks checkout if variants are inactive, out of stock, price hidden, or pricing pending.
- Shipping: flat $5 for the first cart item plus $4 per additional item.
- Bulky items add $5 each.
- Tax uses `tax_rates` (state defaults to WA).
- Orders store subtotal, shipping, bulky fee, tax, and total.

## Admin uploads (Heroku)
- Image uploads for products and events must be done on the Heroku admin host in production.
- The product edit page on Heroku is uploads-only; edit product details on the main admin domain.
- Event details remain editable on any host; only uploads require Heroku.

## S3 images + image proxy
- Product images live under `products/<slug>/main.<ext>` and `products/<slug>/alt.<ext>`.
- Event images live under `events/<id>/main.<ext>` and `events/<id>/alt.<ext>`.
- If `IMAGE_PROXY_BASE_URL` and `IMAGE_PROXY_SIGNING_KEY` are set, thumbnail URLs use the proxy; otherwise S3 presigned URLs are used (requires AWS credentials).

## Inventory
- Inventory is tracked per product variant.
- Update stock and active status from the admin variant edit screen.

## Vendor management
- Vendors store supplier contact info and are used for pricing links.
- Vendor pricing links connect vendors to variants with unit cost, MSRP, lead time, and notes.

## Admin ledger (expenses)
- Admin → Ledger tracks out-of-pocket spend and who the business owes.
- Each entry records description, owed to, amount, spent-on date, reimbursed flag, and notes.

## Docs
- Docs are managed in Admin → Docs.

## Payments and inventory
- PayPal create/capture calls create `Order` and `OrderItem` records and decrement variant stock.

## Notes
- In production, admin uploads redirect to the Heroku admin host defined in the admin services.
