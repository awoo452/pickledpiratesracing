# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# About

About.create!(
  title: "Pickled Pirates",
  body: "World champion beer drinkers"
)

# Products

hat = Product.create!(
  name: "Pickled Pirates Racing Hat",
  description: "Adjustable black snapback hat with embroidered Pickled Pirates Racing logo.",
  price: 24.99,
  image: "logodark.png",
  featured: true
)

flag = Product.create!(
  name: "Pickled Pirates Racing Flag",
  description: "3x5 ft shop / garage flag with the Pickled Pirates Racing logo.",
  price: 24.99,
  image: "logodark.png",
  featured: true
)

sticker = Product.create!(
  name: "Pickled Pirates Racing Sticker",
  description: "High quality vinyl sticker. Weather resistant.",
  price: 4.99,
  image: "logodark.png",
  featured: true
)

shirt = Product.create!(
  name: "Pickled Pirates Racing T-Shirt",
  description: "Black cotton t-shirt with Pickled Pirates Racing logo on the front.",
  price: 29.99,
  image: "logodark.png",
  featured: true
)

keychain = Product.create!(
  name: "Pickled Pirates Racing Keychain",
  description: "Metal keychain with Pickled Pirates Racing logo. Durable and lightweight.",
  price: 9.99,
  image: "logodark.png",
  featured: true
)

crewneck = Product.create!(
  name: "Pickled Pirates Racing Crew Neck",
  description: "Quality lightweight crew neck sweatshirt with logo.",
  price: 59.99,
  image: "logodark.png",
  featured: true
)

# Shirt variants

shirt_colors = [ "Black", "White" ]
shirt_sizes = [ "Kids", "S", "M", "L", "XL", "2XL", "3XL" ]

shirt_colors.each do |color|
  shirt_sizes.each do |size|
    ProductVariant.create!(
      product: shirt,
      name: "#{color} / #{size}",
      stock: 50
    )
  end
end

# Sticker variants

[ "Black", "White" ].each do |color|
  ProductVariant.create!(
    product: sticker,
    name: color,
    stock: 200
  )
end

# Video

Video.create!(
  title: "Pickled Pirates Racing Playlist",
  youtube_playlist_id: "PLHno3IJ04is-0SqgevE25D5ga-c8U9rGB",
  featured: true,
  category: "featured"
)

# Dummy User

user = User.find_or_create_by!(email: "testuser@test.com") do |u|
  u.password = "testuser123"
  u.password_confirmation = "testuser123"
end

# Test Order

user = User.first
variant = ProductVariant.first

if user && variant
  price = variant.price_override || variant.product.price

  order = Order.create!(
    user: user,
    status: "paid",
    total: price
  )

  OrderItem.create!(
    order: order,
    product_variant: variant,
    quantity: 1,
    price_at_purchase: price
  )
end

puts "Seeded products, variants, test order, and video."
