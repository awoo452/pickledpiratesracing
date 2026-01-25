## [0.1.30] - 2026-01-25

### Changed
- Bumped dependencies: devise 5.0.0, puma 7.2.0, selenium-webdriver 4.40.0, turbo-rails 2.0.21, bootsnap 1.21.1, solid_queue 1.3.1.

## [0.1.29] - 2026-01-25

### Changed
- Improved layout wrapping on small screens.
- Fixed RuboCop linting issues (whitespace, spacing, missing newlines).
- Fixed RuboCop linting in Devise initializer, development config, and about controller.
- Pinned minitest to 5.27.x to resolve Rails test runner argument mismatch.
- Auto-corrected remaining RuboCop spacing issues.
- Fixed test fixtures by adding users and wiring rewards to users.
- Updated controller tests to use correct route helpers and auth.
- Fixed test fixtures/assets and restored videos helper for tests.

## [0.1.28] - 2026-01-25

### Changed
- Price validation now respects the “Coming Soon” toggle (price optional when hidden).
- Admin product update now surfaces validation failures via flash.

## [0.1.27] - 2026-01-25

### Changed
- Added heading font variables and Google Font import (Bebas Neue).
- Softened heading contrast and applied nav uppercase typography consistently.
- Improved landing hero bottom radius handling.
- Fixed videos index iframe wrapper for responsive sizing.
- Reworked landing CTA placement and styling, with larger button on wide screens.
- Removed landing image border/radius styling.

## [0.1.26] - 2026-01-25

### Changed
- Added basic param guarding and user feedback for contact and enhancement request forms.
- Improved admin product image upload error handling and empty upload feedback.
- Clamped product descriptions on products index for consistent card heights.
- Added enhancement request validation and eager-loaded admin order details.
- Added model validations (products, variants, videos, rewards, order items).
- Added empty-state messaging for products and videos.
- Normalized admin authorization alert for product uploads.
- Added per-product price hiding with “Coming Soon” display and admin toggle.

## [0.1.25] - 2026-01-25

### Changed
- Split frontend styles into page/feature CSS files with an `app.css` entrypoint.
- Rebuilt landing page video section and moved sizing/layout to CSS.
- Matched `/videos` styling to landing videos and added single-video full-width sizing.
- Added landing CTA for not signed in user
- Clamped product card descriptions.

## [0.1.24] - 2026-01-22

### Added
- S3 product image gallery support (main + alt images).
- Admin upload selector for image type (main / alt).
- Automatic S3 key structure: products/:slug/main.ext, alt.ext.
- Thumbnail image switching on product show page.
- New reward for 'involuntary site tester' added to user model since we're just gonna be pushing to production like this

### Fixed
- S3 upload argument order bug in Admin::ProductsController.
- Ensured main image always loads first via explicit S3 key sorting.

### Changed
- Product show page now uses thumbnail gallery instead of single image.

## [0.1.23] - 2026-01-22

### Added
- 'feedback' section implemented

## [0.1.22] - 2026-01-21

### Added
- Videos was not text-align center and it was really pissing me off

## [0.1.21] - 2026-01-21

### Added
- Basic contact me page (Turns out you can't tell chatGPT to add a contact page to your rails app and push it to production without testing. It doesn't work. Hell this one probably won't either. Clankers man.)

## [0.1.20] - 2026-01-21

### Added
- Basic contact me page

## [0.1.19] - 2026-01-21

### Added
- pickledpiratesracing.com domain added to AWS SES, config for that

## [0.1.18] - 2026-01-21

### Added
- Admin dashboard root at `/admin` with quick links for common actions

### Changed
- Removed product edit shortcut dropdown from admin dashboard (direct product access only)
- Admin navigation now links to dashboard root instead of individual admin pages

### Notes
- Product editing remains available per-product via `/admin/products/:id/edit`
- Dashboard intentionally minimal (variants + orders only)

## [0.1.17] - 2026-01-21

### Added
- Admin product image uploads to private S3 using presigned URLs
- Slug field on products for stable S3 object paths (`products/:slug/main.png`)

### Changed
- Product images now load from S3 when `image_key` is present
- Fallback to legacy `/assets/images/*` when no S3 image exists
- Frontend product views updated to support both S3 and legacy images
- Image uploads must be performed via the Heroku app URL (not the CloudFront domain)

### Fixed
- Admin product edit/update routing under `/admin/products`
- S3 upload failures caused by missing region and bucket configuration
- Product image rendering returning 404 when bucket is private

### Notes
- Existing products without slugs will fail S3 uploads until a slug is set
- Legacy `image` column remains for backward compatibility

## [0.1.16] - 2026-01-21
- I hate chatGPT. That's all you get here.

## [0.1.15] - 2026-01-21

### Added
- Admin product image upload system using direct S3 storage
- `image_key` column on products for S3 object path tracking
- Admin product edit page for uploading product images
- S3 upload service using AWS SDK (`S3Service`)
- Slug-based product image paths (`products/:slug/main.png`)

### Changed
- Product images are now stored in S3 instead of local assets
- Admin product editing moved under `/admin/products/:id/edit`
- Product model now enforces unique slugs for stable image paths

### Infrastructure
- AWS S3 integration for product media storage
- CloudFront-compatible object structure for CDN delivery

### Notes
- Existing products retain `image_key = NULL` until an image is uploaded
- Requires environment variables: `AWS_REGION`, `AWS_BUCKET`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

## [0.1.14] - 2026-01-20

### Changed
- `models/user.rb` another reward added, for creating account before Estranged Drags 2026

## [0.1.13] - 2026-01-20

### Changed
- CSS for the rest of the app to polish the turd

## [0.1.12] - 2026-01-20

### Changed
- CSS for about page to center the crap

## [0.1.11] - 2026-01-20

### Added
- Admin navigation link for creating product variants

### Changed
- Product variant routes moved under admin namespace
- Product variant form updated to use admin-scoped routing helpers

### Security
- Restricted product variant management to authenticated users with admin = true

## [0.1.10] - 2026-01-20

### Added
- Product variant selector to product show page
- Dynamic PayPal pricing based on selected variant price_override
- Live price updates when switching variants on frontend

### Fixed
- Correct handling of null vs zero price_override values
- Variant dropdown rendering (option labels restored)
- Prevented duplicate PayPal button rendering on Turbo navigation

### Changed
- Product purchase flow now resolves pricing at variant level instead of product level

## [0.1.9] - 2026-01-20

### Added
- Product variants support on product show page
  - Variant selection UI (size/color/etc)
  - Dynamic price resolution using variant price_override or base product price
- PayPal checkout integration updated to support variant pricing
- Frontend variant selection passed into PayPal purchase_units amount
- Variant-aware order architecture finalized:
  - Orders contain variant-level OrderItems
  - Each OrderItem references ProductVariant
- Stock tracking groundwork for variants
- Footer added, basically borrowed from closeenoughfabrication.com #shameless plug

### Changed
- Product show page updated to render variant options instead of static pricing
- PayPal button logic updated to wait for SDK availability and Turbo navigation
- Pricing logic standardized:
  - Variant price_override takes precedence
  - Falls back to product.price when null
- Admin order views display variant names instead of base product only
- Seed data expanded to include variant inventory and pricing

### Notes
- PayPal sandbox used for testing checkout flow
- Order persistence and webhook processing deferred until PayPal Business account setup
- Current implementation supports full UI and pricing validation without live payments

## [0.1.8] - 2026-01-16

### Changed
- Some updates to product styling on landing page and products/index so they match lol
- Also updated account show and related CSS

## [0.1.7] - 2026-01-16

### Changed
- About page now shows an image too!!!!!!1

## [0.1.6] - 2026-01-16

### Changed
- Admin orders index redesigned with structured table layout
- Admin order show page redesigned using card-based layout
- Added status badge styling for order states (pending, paid, shipped, cancelled)
- Improved admin UI spacing, typography, and table readability
- Standardized currency formatting for order totals
- Added navigation link back to orders index from order show page

## [0.1.5] - 2026-01-16

### Added
- `/about` page route (`www.pickledpiratesracing.com/about`)
- About model and database table (`about`)
- Admin-editable About content stored in database
- About page view rendering database content

### Changed
- Renamed default Rails `abouts` table to singular `about` to match human logic

## [0.1.4] - 2026-01-16

### Added
- Product variants system
  - ProductVariant model with name, stock, price_override, active flag
  - Associations between products and variants
  - Seed data for shirt size/color variants and sticker color variants
- Orders system
  - Order model with user association, status, and total
  - OrderItem model for variant-level line items
  - Order → User and Order → OrderItems relationships
- Admin namespace foundation
  - Admin::BaseController
  - Admin::OrdersController (index + show)
  - Admin routes scaffolded
- Admin authorization flag
  - `admin` boolean column added to users (default false, non-null)
- Order seeding
  - Test user created via seeds
  - Sample order + order item generated for admin testing
- Product variant pricing resolution logic (price_override fallback to product price)

### Changed
- Seed file rebuilt to support:
  - products
  - variants
  - test user
  - orders
  - order items
- Product show page updated to support variant selection
- PayPal checkout updated to use selected variant pricing
- Navigation updated to support admin routing paths
- Devise logout converted from link to button for proper DELETE behavior
- Minor CSS cleanup for nav layout and admin compatibility

### Notes
- Orders are stored independently of PayPal callbacks (currently sandbox driven)
- Variant pricing model supports per-variant overrides without duplicating products
- Admin UI is intentionally minimal and backend-first
- Order system designed to support future fulfillment + shipping status flow

### Changed
- ChatGPT will never figure out that a link to sign_out with devise does not work and it needs to be a button. But sure, AI is taking over.

## [0.1.3] - 2026-01-15

### Added
- Devise authentication system for user accounts (registration, login, logout)
- User model and authentication routes
- Generated Devise views for account management
- Rewards model and migration
- “Founding Member / First Hundred” reward will be granted on user signup
- AccountController with authenticated show page
- Account page displaying user rewards
- Nav updated to include basic account info

### Notes
- Rewards are user-scoped and intended for future physical fulfillment
- Initial reward system is intentionally minimal and non-gamified

## [0.1.2] - 2026-01-13

### Added
- css styling, landing image updated

## [0.1.1] - 2026-01-13

### Added
- VideosController with index action
- Videos index page displaying all videos using existing YouTube embed helper
- Videos link added to main navigation
- Landing page hero section with background image (landing.jpg)
- Styled product cards and product show layout with scoped CSS
- Styled videos grid layout with scoped CSS
- Component-scoped CSS for:
  - Navigation
  - Landing page
  - Products index
  - Product show
  - Videos index

### Changed
- Refactored global CSS to component-scoped classes to avoid global element styling
- Products index view restructured for grid-based layout
- Product show view restructured for card-based layout and PayPal isolation
- PayPal rendering logic updated to guard against double-render caused by Turbo lifecycle
- PayPal container explicitly marked turbo-disabled
- Product navigation links hardened to prevent Turbo interference

## [0.1.0] - 2026-01-13

### Added
- HomeController with index action loading featured products and featured videos
- ProductsController with index and show actions
-Product model with name, description, price, image, and featured flag
- Video model with title, youtube_id, youtube_playlist_id, and featured flag
- VideosHelper for embedding single videos and playlists
- Seed data for products and videos
- Shared navigation partial with logo, Home link, and Products link
- Landing page displaying logo, featured products, and featured videos
- Products index view with image, name, price, and navigation links
- Product show view with image, description, price, and PayPal checkout
- PayPal JS SDK integration for product purchases

### Changed
- Application layout updated to include shared navigation
- Navigation and product links configured to disable Turbo for JS compatibility
- PayPal button rendering logic updated to wait for SDK availability and handle Turbo page loads
- Asset usage updated to rely on Rails helpers for production compatibility
- database config file fixed for Heroku cable queue cache fit
