class HomeController < ApplicationController
  def index
    data = Home::IndexData.call
    @featured_products = data.featured_products
    @featured_videos = data.featured_videos
  end
end
