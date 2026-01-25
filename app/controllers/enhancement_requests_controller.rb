class EnhancementRequestsController < ApplicationController
  def new
  end

  def create
    if enhancement_request_params[:message].blank?
      redirect_back fallback_location: root_path, alert: "Request message is required"
      return
    end

    EnhancementRequest.create(
      email: enhancement_request_params[:email],
      message: enhancement_request_params[:message]
    )
    redirect_back fallback_location: root_path, notice: "Request submitted"
  end

  private

  def enhancement_request_params
    params.permit(:email, :message)
  end
end
