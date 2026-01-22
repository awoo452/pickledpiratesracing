class EnhancementRequestsController < ApplicationController
  def new
  end

  def create
    EnhancementRequest.create!(
      email: params[:email],
      message: params[:message]
    )
    redirect_back fallback_location: root_path
  end
end
