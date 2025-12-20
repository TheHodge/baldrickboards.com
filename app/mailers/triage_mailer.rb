class TriageMailer < ApplicationMailer
  default from: Rails.application.credentials[:mail_from] || 'hello@littlewarden.com'
  default reply_to: Rails.application.credentials[:mail_reply_to] || 'hello@littlewarden.com'

  def case_created(case_record)
    @case = case_record
    
    # Generate a signed token that includes email and case_number
    # This can be verified without storing anything in session/database
    verifier = Rails.application.message_verifier('triage_case_magic_link')
    token_data = {
      email: @case.email.downcase,
      case_number: @case.case_number,
      expires_at: 30.days.from_now.to_i
    }
    signed_token = verifier.generate(token_data)
    
    # Create magic link that logs them in and redirects to their case
    @magic_link = magic_link_login_triage_cases_url(
      token: signed_token,
      locale: I18n.locale
    )
    
    mail(
      to: @case.email,
      subject: "Christmas Triage - Case ##{@case.case_number} Created"
    )
  end

  def case_created_admin(case_record)
    @case = case_record
    @case_url = admin_triage_case_url(@case, locale: I18n.locale)
    
    mail(
      to: Rails.application.credentials[:contact_email] || 'dom@ilightthat.com',
      subject: "New Christmas Triage Case: ##{@case.case_number} - #{@case.name}"
    )
  end

  def magic_link(email, login_url)
    @email = email
    @login_url = login_url
    
    mail(
      to: email,
      subject: "Christmas Triage - Magic Link Login"
    )
  end

  def admin_comment(case_record, comment)
    @case = case_record
    @comment = comment
    
    # Generate a magic link so they can view their case
    verifier = Rails.application.message_verifier('triage_case_magic_link')
    token_data = {
      email: @case.email.downcase,
      case_number: @case.case_number,
      expires_at: 30.days.from_now.to_i
    }
    signed_token = verifier.generate(token_data)
    
    @case_url = magic_link_login_triage_cases_url(
      token: signed_token,
      locale: I18n.locale
    )
    
    mail(
      to: @case.email,
      subject: "Update on Your Christmas Triage Case ##{@case.case_number}"
    )
  end
end
