class HomeController < ApplicationController
  def index
    @featured_products = Product.where(featured: true)
    @featured_videos = Video.where(featured: true)
  end
end
