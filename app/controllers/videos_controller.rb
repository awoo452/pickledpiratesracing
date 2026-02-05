class VideosController < ApplicationController
  def index
    data = Videos::IndexData.call
    @videos = data.videos
  end
end
