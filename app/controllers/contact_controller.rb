# app/controllers/contact_controller.rb
class ContactController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    if contact_params[:email].blank? || contact_params[:message].blank?
      redirect_to contact_path, alert: "Email and message are required"
      return
    end

    ContactMailer.contact_email(
      contact_params[:email],
      contact_params[:message]
    ).deliver_later

    redirect_to contact_path, notice: "Message sent"
  end

  private

  def contact_params
    params.permit(:email, :message)
  end
end
