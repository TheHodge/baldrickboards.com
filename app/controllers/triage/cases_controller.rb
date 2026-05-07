class Triage::CasesController < ApplicationController
  before_action :set_case, only: [:show, :edit, :verify_access, :mark_solved, :mark_solution_fixed, :update, :add_comment]
  before_action :check_edit_access, only: [:edit, :update, :mark_solved, :mark_solution_fixed, :add_comment]

  def index
    @cases = Case.not_spam.recent.limit(50)
  end

  def my_cases
    if triage_user_email.present?
      @cases = Case.by_email(triage_user_email).not_spam.recent
    else
      redirect_to triage_cases_path, alert: 'Please log in to view your cases.'
    end
  end

  def send_magic_link
    email = params[:email]&.strip&.downcase
    
    unless email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      flash[:alert] = 'Please enter a valid email address.'
      redirect_to triage_cases_path
      return
    end

    # Check if email has any cases
    unless Case.by_email(email).exists?
      flash[:alert] = 'No cases found for this email address.'
      redirect_to triage_cases_path
      return
    end

    # Generate magic link token
    token = SecureRandom.urlsafe_base64(32)
    session[:triage_magic_link_token] = token
    session[:triage_magic_link_email] = email
    session[:triage_magic_link_expires_at] = 1.hour.from_now

    # Send magic link email
    TriageMailer.magic_link(email, magic_link_login_triage_cases_url(token: token)).deliver_now

    # Redirect to a confirmation page
    redirect_to magic_link_sent_triage_cases_path(email: email)
  end

  def magic_link_sent
    @email = params[:email]
    unless @email.present?
      redirect_to triage_cases_path, alert: 'Invalid request.'
      return
    end
  end

  def magic_link_login
    token = params[:token]
    
    # Try to verify signed token (from case creation email)
    begin
      verifier = Rails.application.message_verifier('triage_case_magic_link')
      token_data = verifier.verify(token)
      
      # Token data comes back with string keys, not symbols
      email = token_data['email'] || token_data[:email]
      case_number = token_data['case_number'] || token_data[:case_number]
      expires_at_timestamp = token_data['expires_at'] || token_data[:expires_at]
      
      # Handle expires_at - it might be a Time object or a timestamp
      expires_at = if expires_at_timestamp.is_a?(Time)
        expires_at_timestamp
      elsif expires_at_timestamp.is_a?(Integer) || expires_at_timestamp.is_a?(Float)
        Time.at(expires_at_timestamp)
      else
        # Default to 30 days from now if not provided
        30.days.from_now
      end
      
      if expires_at > Time.current && email.present? && case_number.present?
        # Login successful
        session[:triage_user_email] = email
        session[:triage_user_logged_in_at] = Time.current
        
        # Grant access to the specific case
        case_record = Case.find_by(case_number: case_number)
        if case_record
          session["case_#{case_record.id}_verified"] = true
          session["case_#{case_record.id}_verified_at"] = Time.current
          session["case_#{case_record.id}_verified_email"] = email
          
          redirect_to triage_case_path(case_number), notice: 'Successfully logged in!'
        else
          redirect_to my_cases_triage_cases_path, notice: 'Successfully logged in!'
        end
        return
      end
    rescue ActiveSupport::MessageVerifier::InvalidSignature, ArgumentError => e
      # Token is invalid, try session-based token (from send_magic_link)
      Rails.logger.debug "Signed token verification failed: #{e.message}"
    end
    
    # Fallback to session-based token (for send_magic_link flow)
    stored_token = session[:triage_magic_link_token]
    stored_email = session[:triage_magic_link_email]
    expires_at = session[:triage_magic_link_expires_at]

    if token.present? && 
       token == stored_token && 
       stored_email.present? && 
       expires_at.present? && 
       Time.parse(expires_at) > Time.current
      
      # Login successful
      session[:triage_user_email] = stored_email
      session[:triage_user_logged_in_at] = Time.current
      
      # Clear magic link session data
      session.delete(:triage_magic_link_token)
      session.delete(:triage_magic_link_email)
      session.delete(:triage_magic_link_expires_at)

      redirect_to my_cases_triage_cases_path, notice: 'Successfully logged in!'
    else
      flash[:alert] = 'Invalid or expired magic link.'
      redirect_to triage_cases_path
    end
  end

  def new
    @case = Case.new
    # Pre-populate email and name if user is logged in
    if triage_user_logged_in? && triage_user_email.present?
      @case.email = triage_user_email
      # Try to get name from most recent case
      recent_case = Case.by_email(triage_user_email).order(created_at: :desc).first
      @case.name = recent_case.name if recent_case&.name.present?
      # If no name found, use email username as fallback
      @case.name ||= triage_user_email.split('@').first.titleize
    end
  end

  def create
    # Extract media files before creating case (to prevent automatic attachment)
    media_files = if params[:case][:media].present?
      Array(params[:case][:media]).reject(&:blank?).select { |f| f.is_a?(ActionDispatch::Http::UploadedFile) }
    else
      []
    end
    
    # Remove media from params to prevent automatic attachment
    case_params_without_media = case_params.except(:media)
    @case = Case.new(case_params_without_media)
    
    # Capture IP address for admin tracking
    @case.ip_address = real_client_ip

    if @case.save
      # Attach media files manually (images and videos)
      if media_files.present?
        # Remove duplicates based on filename and size
        unique_files = media_files.uniq { |f| [f.original_filename, f.size] }
        unique_files.each do |file|
          @case.media.attach(file)
        end
      end

      # Match solutions
      matched_solutions = @case.match_solutions

      # Automatically grant session access to the case creator
      # This allows them to edit the case without needing to enter access code
      session["case_#{@case.id}_verified"] = true
      session["case_#{@case.id}_verified_at"] = Time.current
      session["case_#{@case.id}_verified_email"] = @case.email.downcase

      # Send emails
      TriageMailer.case_created(@case).deliver_now
      TriageMailer.case_created_admin(@case).deliver_now

      # Sync to Todoist (non-blocking for user flow)
      Todoist::CaseSync.sync_create(@case)

      # Redirect to case show page (no access token needed for viewing)
      redirect_to triage_case_path(@case.case_number),
                  notice: 'Case created successfully! Check your email for access code.',
                  status: :see_other
    else
      flash.now[:alert] = 'There were errors creating your case. Please check the form below.'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Check if case is spam - redirect if so (unless admin)
    if @case.spam? && !admin_authenticated?
      redirect_to triage_cases_path, alert: 'Case not found.'
      return
    end

    @solutions = @case.solutions.includes(:case_solutions)
                      .order('case_solutions.match_score DESC')
                      .limit(5)
    # Eager load comments for display
    @case.case_comments.load
    # Eager load solved_by_solution association
    @case = Case.includes(:solved_by_solution).find(@case.id)
  end

  def verify_access
    if request.post?
      # POST request - verify the code
      entered_code = params[:access_code]&.strip

      if entered_code == @case.access_code
        # Store verified access in session
        session["case_#{@case.id}_verified"] = true
        session["case_#{@case.id}_verified_at"] = Time.current
        session["case_#{@case.id}_verified_email"] = @case.email.downcase

        redirect_to triage_case_path(@case.case_number),
                    notice: 'Access granted!'
      else
        flash.now[:alert] = 'Invalid access code. Please try again.'
        render :verify_access, status: :unprocessable_entity
      end
    else
      # GET request - show the form
    end
  end

  def mark_solved
    # Authorization checked in before_action
    # Only allow if case is open
    unless @case.open?
      redirect_to triage_case_path(@case.case_number),
                  alert: 'This case is already solved or closed.'
      return
    end
    
    # Load solutions for the form
    @solutions = @case.solutions.includes(:case_solutions)
                      .order('case_solutions.match_score DESC')
                      .limit(5)
  end

  def mark_solution_fixed
    # Authorization checked in before_action (check_edit_access)

    # Only allow if case is open
    unless @case.open?
      redirect_to triage_case_path(@case.case_number),
                  alert: 'This case is already solved or closed.'
      return
    end

    solution_id = params[:solution_id]
    custom_solution = params[:custom_solution]&.strip

    # Either solution_id or custom_solution must be provided
    if solution_id.blank? && custom_solution.blank?
      @solutions = @case.solutions.includes(:case_solutions)
                        .order('case_solutions.match_score DESC')
                        .limit(5)
      flash.now[:alert] = 'Please select a solution or provide your own solution.'
      render :mark_solved, status: :unprocessable_entity
      return
    end

    if solution_id.present?
      solution = Solution.find_by(id: solution_id)
      unless solution
        @solutions = @case.solutions.includes(:case_solutions)
                          .order('case_solutions.match_score DESC')
                          .limit(5)
        flash.now[:alert] = 'Solution not found.'
        render :mark_solved, status: :unprocessable_entity
        return
      end
      # Mark case as solved with suggested solution
      @case.update!(status: 'solved', solved_by_solution_id: solution.id, custom_solution: nil)
      # Increment success count on solution
      solution.increment_success!
    else
      # Mark case as solved with custom solution
      @case.update!(status: 'solved', solved_by_solution_id: nil, custom_solution: custom_solution)
    end

    Todoist::CaseSync.sync_status(@case, @case.status)

    redirect_to triage_case_path(@case.case_number),
                notice: 'Thank you for letting us know! Your case has been marked as solved.'
  end

  def edit
    # Authorization checked in before_action
  end

  def update
    # Authorization checked in before_action
    if @case.update(case_params)
      redirect_to triage_case_path(@case.case_number),
                  notice: 'Case updated successfully.'
    else
      flash.now[:alert] = 'There were errors updating your case.'
      render :edit, status: :unprocessable_entity
    end
  end

  def add_comment
    content = params[:content]&.strip
    if content.blank?
      redirect_to triage_case_path(@case.case_number), alert: "Please enter a comment before sending."
      return
    end

    commenter_name = @case.name.presence || "Case Owner"
    comment = @case.case_comments.build(content: content, admin_name: commenter_name)

    if comment.save
      Todoist::CaseSync.sync_comment(@case, comment, source: "User reply")
      redirect_to triage_case_path(@case.case_number), notice: "Reply sent to the support team."
    else
      redirect_to triage_case_path(@case.case_number), alert: "Failed to send reply: #{comment.errors.full_messages.join(', ')}"
    end
  end

  def logout
    # Logout action
    session.delete(:triage_user_email)
    session.delete(:triage_user_logged_in_at)
    redirect_to triage_cases_path, notice: 'Successfully logged out.'
  end

  private

  def set_case
    # Find by case_number only (no longer using access_token in URLs)
    @case = Case.find_by(case_number: params[:id])
    
    unless @case
      redirect_to new_triage_case_path, alert: 'Case not found.'
    end
  end

  def check_edit_access
    # Check authorization: only case creator (logged in) or admin can edit
    unless can_edit_case?
      redirect_to triage_case_path(@case.case_number),
                  alert: 'You do not have permission to edit this case.'
    end
  end

  def check_case_access
    # Check if user is logged in (for future login integration)
    # if current_user && @case.belongs_to_user?(current_user)
    #   return # Allow access
    # end

    # Check if already verified in session (no longer checking URL params for access_token)
    if session["case_#{@case.id}_verified"]
      # Check if verification is still valid (24 hours)
      verified_at = session["case_#{@case.id}_verified_at"]
      if verified_at && Time.parse(verified_at) > 24.hours.ago
        return # Allow access
      end
    end

    # No valid access - redirect to verify
    redirect_to verify_access_triage_case_path(@case.case_number),
                alert: 'You need to verify access to edit this case. Please enter your access code.'
  end

  def case_params
    params.require(:case).permit(
      :name,
      :email,
      :problem_description,
      :tried_solutions,
      :knowledge_level,
      :baldrick_version,
      :fpp_version,
      :xlights_version,
      :operating_system,
      :system_state,
      :fpp_outputs_state,
      :custom_solution,
      affected_boards: [],
      media: []
    )
  end

  def triage_user_email
    session[:triage_user_email] if triage_user_logged_in?
  end

  def triage_user_logged_in?
    return false unless session[:triage_user_email].present?
    logged_in_at = session[:triage_user_logged_in_at]
    return false unless logged_in_at.present?
    Time.parse(logged_in_at) > 30.days.ago
  end

  def can_mark_solution_fixed?
    can_edit_case?
  end

  def can_edit_case?
    # Check if user is an admin
    return true if admin_authenticated?
    
    # Check if user is logged in via triage email and case belongs to that email
    if triage_user_logged_in? && triage_user_email.present?
      return true if @case.belongs_to_email?(triage_user_email)
    end
    
    # Check if already verified in session (via access code or case creation) and email matches
    if session["case_#{@case.id}_verified"]
      verified_at = session["case_#{@case.id}_verified_at"]
      if verified_at && Time.parse(verified_at) > 24.hours.ago
        # Only allow if the verified email matches the case email
        verified_email = session["case_#{@case.id}_verified_email"]
        return true if verified_email.present? && @case.belongs_to_email?(verified_email)
      end
    end

    false
  end

  def admin_authenticated?
    session[:admin_authenticated] == true
  end

  helper_method :triage_user_email, :triage_user_logged_in?, :can_mark_solution_fixed?, :can_edit_case?

end
