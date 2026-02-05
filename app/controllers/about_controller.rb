class AboutController < ApplicationController
  def show
    data = Abouts::ShowData.call
    @about = data.about
  end
end
