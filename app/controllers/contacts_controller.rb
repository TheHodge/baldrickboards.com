class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    
    if @contact.save
      # Send emails
      ContactMailer.contact_submission(@contact).deliver_now
      ContactMailer.contact_confirmation(@contact).deliver_now
      
      # Mark email as sent
      @contact.mark_email_sent!
      
      # Redirect with success message
      redirect_to support_path, notice: 'Thank you for your message! We\'ll get back to you soon.'
    else
      # Handle validation errors
      flash.now[:alert] = 'Please check the form for errors and try again.'
      render 'support/index', status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
