# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Product.create!(
  name: "Test Shirt",
  description: "Test product",
  price: 25,
  image: "logodark.png",
  featured: true
)

Video.create!(
  title: "Pickled Pirates Racing Playlist",
  youtube_playlist_id: "PLHno3IJ04is-0SqgevE25D5ga-c8U9rGB",
  featured: true
)
