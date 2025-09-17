class ContactMailer < ApplicationMailer
  default from: Rails.application.credentials[:mail_from] || 'hello@littlewarden.com'
  default reply_to: Rails.application.credentials[:mail_reply_to] || 'hello@littlewarden.com'

  def contact_submission(contact)
    @contact = contact
    @subject = "New Contact Form Submission: #{contact.subject}"
    
    mail(
      to: Rails.application.credentials[:contact_email] || 'dom@ilightthat.com',
      subject: @subject,
      reply_to: contact.email
    )
  end

  def contact_confirmation(contact)
    @contact = contact
    
    mail(
      to: contact.email,
      subject: "Thank you for contacting Baldrick Boards"
    )
  end
end
