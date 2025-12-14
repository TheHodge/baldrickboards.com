class TriageMailer < ApplicationMailer
  default from: Rails.application.credentials[:mail_from] || 'hello@littlewarden.com'
  default reply_to: Rails.application.credentials[:mail_reply_to] || 'hello@littlewarden.com'

  def case_created(case_record)
    @case = case_record
    # No longer including access_token in URL - users should use access code or magic link
    @case_url = triage_case_url(@case.case_number, locale: I18n.locale)
    
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
end
