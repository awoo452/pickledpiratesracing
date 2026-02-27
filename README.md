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

## Environment variables
- `PAYPAL_CLIENT_ID` (required to render PayPal buttons)
- `PAYPAL_SECRET`
- `PAYPAL_ENV` (defaults to `sandbox`, set to `live` for production)
- `AWS_REGION` or `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_BUCKET`
- `IMAGE_PROXY_BASE_URL` (optional, signed resize URLs for thumbnails)
- `IMAGE_PROXY_SIGNING_KEY` (optional, signed resize URLs for thumbnails)
- `CONTACT_EMAIL` (defaults to `pickledpiratescc@gmail.com`)
- `SES_SMTP_USERNAME` (production mail)
- `SES_SMTP_PASSWORD` (production mail)
- `DATABASE_URL` (production)
- `RAILS_LOG_LEVEL`
- `RAILS_MAX_THREADS`
- `PORT`
- `JOB_CONCURRENCY`

## Admin notes
- Set `users.admin = true` to access admin pages.
- Docs are managed in Admin > Docs (see `currentdocs.sql` for current reference).

## Payments and inventory
- PayPal create/capture calls create `Order` and `OrderItem` records and decrement variant stock.
- Products must have at least one active variant with stock > 0 and `price_hidden = false` to be purchasable.

## S3 uploads
- Image uploads use S3. Set the AWS variables above to enable uploads and deletes.
- In production, admin uploads redirect to the Heroku admin host defined in the admin services.
