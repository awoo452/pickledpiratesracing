# app/mailers/contact_mailer.rb
class ContactMailer < ApplicationMailer
  def contact_email(email, message)
    @email = email
    @message = message

    mail(
      to: ENV.fetch("CONTACT_EMAIL", "pickledpiratescc@gmail.com"),
      subject: "Contact form message"
    )
  end
end
