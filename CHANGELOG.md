## [0.1.4] - 2026-01-15

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