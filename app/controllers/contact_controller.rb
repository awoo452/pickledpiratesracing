# app/controllers/contact_controller.rb
class ContactController < ApplicationController
  def new
  end

  def create
    ContactMailer.contact_email(
      params[:email],
      params[:message]
    ).deliver_later

    redirect_to contact_path, notice: "Message sent"
  end
end
