class ContactMailer < ApplicationMailer
  default from: ENV.fetch('MAIL_FROM', 'noreply@baldrickboards.com')
  default reply_to: ENV.fetch('MAIL_REPLY_TO', 'support@baldrickboards.com')

  def contact_submission(contact)
    @contact = contact
    @subject = "New Contact Form Submission: #{contact.subject}"
    
    mail(
      to: ENV.fetch('CONTACT_EMAIL', 'support@baldrickboards.com'),
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
