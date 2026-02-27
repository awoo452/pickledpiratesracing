

## [0.1.100] - 2026-02-27

### Added
- Added a `comingsoon.png` fallback for missing product and event images.

## [0.1.99] - 2026-02-26

### Added
- Added `image_proxy_url` helper to support signed resize URLs for thumbnails.
- Documented optional image proxy environment variables.

### Changed
- Updated product and event views to prefer proxy-backed thumbnail URLs when available.

## [0.1.98] - 2026-02-24

### Fixed
- Added a safe S3 media proxy with an allowlist to prevent open redirects.
- Switched product and event image URLs to use the stable `/media/*` proxy path.

## [0.1.97] - 2026-02-24

### Changed
- Pinned Ruby to 4.0.1 and Rails to 8.1.2.

## [0.1.96] - 2026-02-22

### Added
- LICENSE file.

## [0.1.95] - 2026-02-20

### Fixed
- Cleaned up RuboCop style issues in admin controllers, product model array/hash formatting, and service alignment.
- Updated contact controller tests to sign in before hitting authenticated actions.

### Changed
- Bumped Brakeman to 8.0.2 to satisfy CI version checks.

## [0.1.94] - 2026-02-11

### Changed
- Normalized video categories to include past events and burnouts, with updated front-end sections.

## [0.1.93] - 2026-02-11

### Changed
- Overhauled About page layout with a bold hero, mission callout, and dedicated CTA panel.
- Added the About hero image under the title and expanded CTA links.
- Renamed the About hero background asset to a descriptive filename.
- Restyled the Videos page with a hero panel, category sections, and series placeholders.
- Simplified the Videos hero to a single CTA box with heading, copy, and section links.
- Matched the About hero layout to the Videos hero with a single centered CTA box.
- Rebuilt About and Videos pages on a shared hero layout and added video categories for tagging.
- Added video start timestamps and a Minibikes category for videos.

## [0.1.92] - 2026-02-11

### Added
- Added Swap Meet eras (classic, retro, current) to parts with validation and UI display.
- Added Swap Meet rewards for posting parts (1, 2, 3, 5, 25) and deleting a listing.

### Fixed
- Restricted Swap Meet deletions to post owners, while allowing admins to delete any post.

## [0.1.91] - 2026-02-10

### Added
- Added an internal doc explaining Heroku-only image uploads for products and events.

### Changed
- Gated product and event image uploads to the Heroku admin host with clear call-to-action messaging.
- Hid upload fields when not on the Heroku admin to prevent failed uploads.
- Centralized event upload gating inside the shared form.

## [0.1.90] - 2026-02-08

### Added
- Added a feedback log page that lists enhancement requests with a completed status badge.

### Changed
- Aligned the admin event form layout so image fields sit together like the product edit form.
- Feedback in nav links to index, not new

## [0.1.89] - 2026-02-08

### Added
- Added a completed flag on feedback items.

## [0.1.88] - 2026-02-08

### Changed
- Moved About page CTAs onto the hero image with a cleaner overlay treatment.
- Renamed the account reward action to “Redeem reward code” with clearer input copy.
- Repositioned the admin product save button to the page bottom and removed the full-width stretch.

## [0.1.87] - 2026-02-06

### Fixed
- PayPal endpoints now return JSON 401 for unauthenticated requests instead of redirect HTML.
- PayPal frontend surfaces a clear sign-in message if a non-JSON response is received.

### Changed
- Explicitly load the PayPal SDK on product pages and wait for it before rendering buttons.
- Wired the PayPal Stimulus controller to a stable container with visible status messaging.
- Extracted shared product/video card partials for home and index pages.
- Made S3 image handling safe in dev when AWS env vars are missing.
- Added dotenv support in development/test with a sample `.env.example`.

## [0.1.86] - 2026-02-05

### Changed
- Refactored controllers to delegate to service objects following the `getawd` structure.
- Added domain-scoped services for home, products, events, parts, account, admin, and PayPal flows.

## [0.1.85] - 2026-01-31

### Changed
- New landing image, now referenced on the front end!

## [0.1.84] - 2026-01-31

### Changed
- Refactored main navigation Account menu into a single unified dropdown
- Fixed mobile nav layout issues caused by dropdown spacer pseudo-elements

### Added
- Expanded About page data model to separate content concerns
  - Added eyebrow text field
  - Added lede field for primary description
  - Added image key support for flexible hero imagery

## [0.1.83] - 2026-01-30

### Changed
- 2 days of troubleshooting because once again turbo is slowing things down

## [0.1.82] - 2026-01-30

### Added
- ChatGPT garbage for S3 broken image routing again. Idiot shit.

## [0.1.81] - 2026-01-30

### Added
- Store PayPal order/capture IDs and payment status on orders.

### Fixed
- PayPal capture now decrements variant stock safely inside a transaction with row locking.
- Blank or zero stock is treated as out of stock in the storefront and checkout.
- Variant stock field is optional in admin forms (nil = out of stock).

## [0.1.80] - 2026-01-30

### Added
- Store PayPal order/capture IDs and payment status on orders.

### Fixed
- PayPal capture now decrements variant stock safely inside a transaction with row locking.
- Blank or zero stock is treated as out of stock in the storefront and checkout.
- Variant stock field is optional in admin forms (nil = out of stock).

## [0.1.79] - 2026-01-30

### Fixed
- PayPal order/capture requests now skip CSRF verification to avoid HTML 422 responses.
- PayPal fetch handlers now send credentials/Accept headers and guard against non-JSON responses.

## [0.1.78] - 2026-01-29

### Added
- Server-side PayPal order creation/capture endpoints with DB order creation.
- PayPal API client service and stored PayPal IDs on orders.

### Changed
- Product PayPal flow now uses Rails endpoints and ENV client ID.

## [0.1.77] - 2026-01-29

### Added
- Swap Meet post form now requires a disclaimer acknowledgment checkbox.
- Legal acceptance copy with Terms/Privacy links on sign-up and contact forms.

### Changed
- Styled the Swap Meet disclaimer checkbox layout for readability.
- Added legal helper text styles for auth and contact pages.

## [0.1.76] - 2026-01-29

### Changed
- Locked the contact form to signed-in users to match nav access.

## [0.1.75] - 2026-01-29

### Changed
- Updated fallback contact email for feedback mailer.
- Feedback is admin only for now.

## [0.1.74] - 2026-01-29

### Changed
- Truncated product titles/descriptions on the index and home featured list only.

## [0.1.73] - 2026-01-29

### Added
- Terms and Privacy pages plus footer links.
- Swap Meet disclaimer panel on listing and post form.

### Changed
- Updated nav logo and increased nav height for readability.

## [0.1.72] - 2026-01-29

### Fixed
- Constrained product index images/cards on mobile to prevent overflow.
- Centered product cards on small screens.

## [0.1.71] - 2026-01-29

### Fixed
- Global box-sizing to stop forms from overflowing on mobile.
- Mobile nav dropdowns now open on first tap (hover only on hover-capable devices).

## [0.1.70] - 2026-01-29

### Added
- Sold-out handling for product variants and checkout gating when all variants are out.

## [0.1.69] - 2026-01-29

### Fixed
- Restored admin product variant edit/update routes and view.
- Product can now be completely edited on the /show page, not just edits related to image

## [0.1.68] - 2026-01-29

### Changed
- Centralized shared shadow values into layout variables and reused them.

## [0.1.67] - 2026-01-29

### Changed
- Removed nav separators in favor of clean spacing.

## [0.1.66] - 2026-01-29

### Changed
- Made the nav actually function because ChatGPT might as well be like losing two good developers.

## [0.1.65] - 2026-01-29

### Fixed
- Standardized dropdown padding so the logout button aligns with links.
- Prevented the nav bar from overflowing the viewport width.

## [0.1.64] - 2026-01-29
- Moved About/Videos/Events/Contact into an Explore dropdown.

## [0.1.63] - 2026-01-29

### Changed
- Converted nav separators to CSS-based pipes for consistent spacing.
- Grouped Products/Swap Meet under a Marketplace dropdown.

## [0.1.62] - 2026-01-29

### Added
- Admin and Account dropdowns in the main nav.

## [0.1.61] - 2026-01-29

### Added
- Account page section to manage Swap Meet posts with delete-only controls.
- Admin-only documents section for internal site notes and FAQs.

## [0.1.60] - 2026-01-29

### Added
- Swap Meet parts postings with account-owned listings and a post form.

## [0.1.59] - 2026-01-29

### Changed
- Landing hero now letterboxes the image on wide screens to avoid cropping.
- Constrained landing videos/products sections to a centered max width on large screens.

## [0.1.58] - 2026-01-29

### Added
- First/last name profile fields with a “Profile Completed” reward.

### Changed
- Moved profile name editing to a dedicated edit page.

## [0.1.57] - 2026-01-28

### Changed
- Removed an unused product query from the admin dashboard.

## [0.1.55] - 2026-01-28

### Changed
- YouTube embeds now auto-load when cookies/storage are available; otherwise they show a play button.

## [0.1.54] - 2026-01-28

### Changed
- YouTube embeds now load on click instead of on page load.
- PayPal script now loads only on product pages (not globally).

## [0.1.53] - 2026-01-28

### Changed
- Standardized public-site CSS to use layout variables for colors and radii.

## [0.1.52] - 2026-01-28

### Changed
- Unified Devise login/signup/reset screens with a clean, consistent layout.

## [0.1.51] - 2026-01-28

### Changed
- Refined feedback form layout, copy, and sizing.

## [0.1.50] - 2026-01-28

### Changed
- Landing CTA now uses an American flag background.

## [0.1.49] - 2026-01-28

### Changed
- Reworked landing hero overlay to avoid overlapping tagline and CTA.

## [0.1.48] - 2026-01-28

### Changed
- Increased the nav logo size.
- Added sitewide CSS variables and wired core public styles to use them.

## [0.1.47] - 2026-01-28

### Added
- New “42069 Club” reward redeemable via the claim form.

### Changed
- Reward claim now supports multiple codes.

## [0.1.46] - 2026-01-28

### Added
- Reward icons (emoji) shown on the account rewards list.

## [0.1.45] - 2026-01-28

### Added
- Admin products list for editing and deleting products.
- Admin dashboard link to manage products.

### Changed
- Removed product admin controls from the public product show page.

## [0.1.44] - 2026-01-28

### Changed
- Product image uploads now auto-redirect to Heroku when started on the custom domain.

## [0.1.43] - 2026-01-28

### Changed
- Events admin upload flow now mirrors the Heroku-only upload path used by products.
- Upload buttons now auto-redirect to the Heroku admin when on the custom domain.

## [0.1.42] - 2026-01-28

### Added
- Event image support with main/alt keys and optional uploads.

### Changed
- Events admin delete now submits a real DELETE request.
- Events admin uploads now mirror the Heroku-only upload flow used by products.

## [0.1.41] - 2026-01-28

### Added
- Events page backed by a new events table.
- Admin events management (create/edit/delete).
- Events nav link and dashboard entry.

### Changed
- Events page now requires a signed-in user.
- Fixed CSS asset loading by linking stylesheets directly in the layout.

## [0.1.40] - 2026-01-28

### Changed
- Updated the landing hero tagline copy.
- Tuned landing hero image height caps across small and wide screens.
- Pinned Ruby to 4.0.1.

## [0.1.39] - 2026-01-28

### Changed
- Refined the About page hero layout, added an eyebrow line, and tightened heading spacing.
- Added an over-hero tagline describing the club on the landing page.
- Removed the rounded corners from video frames.

## [0.1.38] - 2026-01-28

### Added
- Reward claim form for the Estranged Drags 2026 attendee badge.

### Changed
- Added a 2026 attendee reward redeemable with a claim code.

## [0.1.37] - 2026-01-28

### Changed
- Auto-grant the hidden reward for new users until March 1, 2026.

## [0.1.36] - 2026-01-27

### Added
- Admin product delete button on product show page, with S3 cleanup on destroy.

### Changed
- Admin delete action now requires the Heroku domain; main site links out to Heroku for deletion.

## [0.1.35] - 2026-01-27

### Changed
- Admin image upload form now posts to the production Heroku domain in production.

## [0.1.34] - 2026-01-27

### Added
- Admin product creation flow with a new dashboard action and form.

### Fixed
- Auto-generate product slugs when the admin leaves the slug blank.

## [0.1.33] - 2026-01-27

### Changed
- Reworked admin section layout, dashboard cards, and form/table styling.

## [0.1.32] - 2026-01-27

### Changed
- Product show gallery now uses server-rendered thumbnail links to swap the main image without JavaScript.

## [0.1.31] - 2026-01-25

### Changed
- Upgraded Rails to 8.1.2 and updated core framework gems.
- Added Rails 8.1 defaults file, CI config, and new Active Storage migrations.
- Updated Puma, Devise, Turbo, Bootsnap, Solid Queue, and Selenium WebDriver.

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
