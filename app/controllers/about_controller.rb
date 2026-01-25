class AboutController < ApplicationController
  def show
    @about = About.first
  end
end
