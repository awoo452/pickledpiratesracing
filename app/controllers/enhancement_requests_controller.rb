class EnhancementRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def new
  end

  def index
    @requests = EnhancementRequest.order(created_at: :desc)
  end

  def create
    result = EnhancementRequests::CreateRequest.call(
      email: enhancement_request_params[:email],
      message: enhancement_request_params[:message]
    )

    if result.success?
      redirect_back fallback_location: root_path, notice: "Request submitted"
    else
      redirect_back fallback_location: root_path, alert: result.error
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def enhancement_request_params
    params.permit(:email, :message)
  end
end
