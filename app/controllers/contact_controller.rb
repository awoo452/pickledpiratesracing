# app/controllers/contact_controller.rb
class ContactController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    result = Contact::SendMessage.call(
      email: contact_params[:email],
      message: contact_params[:message]
    )

    if result.success?
      redirect_to contact_path, notice: "Message sent"
    else
      redirect_to contact_path, alert: result.error
    end
  end

  private

  def contact_params
    params.permit(:email, :message)
  end
end
