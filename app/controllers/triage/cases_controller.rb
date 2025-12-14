class Triage::CasesController < ApplicationController
  before_action :set_case, only: [:show, :verify_access, :mark_solution_fixed, :update]
  before_action :check_case_access, only: [:mark_solution_fixed, :update]

  def index
    @cases = Case.recent.limit(50)
  end

  def my_cases
    if triage_user_email.present?
      @cases = Case.by_email(triage_user_email).recent
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

    flash[:notice] = 'Magic link sent! Check your email for the login link.'
    redirect_to triage_cases_path
  end

  def magic_link_login
    token = params[:token]
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

      # Send emails
      TriageMailer.case_created(@case).deliver_now
      TriageMailer.case_created_admin(@case).deliver_now

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
    @solutions = @case.solutions.includes(:case_solutions)
                      .order('case_solutions.match_score DESC')
                      .limit(5)
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

  def mark_solution_fixed
    # Check authorization: only case creator or admin can mark solutions as fixed
    unless can_mark_solution_fixed?
      redirect_to triage_case_path(@case.case_number),
                  alert: 'You do not have permission to mark this case as solved.'
      return
    end

    solution_id = params[:solution_id]

    unless solution_id.present?
      redirect_to triage_case_path(@case.case_number),
                  alert: 'No solution specified.'
      return
    end

    solution = Solution.find_by(id: solution_id)

    unless solution
      redirect_to triage_case_path(@case.case_number),
                  alert: 'Solution not found.'
      return
    end

    # Mark case as solved
    @case.mark_as_solved!(solution.id)

    # Increment success count on solution
    solution.increment_success!

    redirect_to triage_case_path(@case.case_number),
                notice: 'Thank you for letting us know! Your case has been marked as solved.'
  end

  def update
    # This action would be for editing case details - requires access token
    # Implementation can be added later if needed
    redirect_to triage_case_path(@case.case_number)
  end

  def logout
    # Logout action
    session.delete(:triage_user_email)
    session.delete(:triage_user_logged_in_at)
    redirect_to triage_cases_path, notice: 'Successfully logged out.'
  end

  private

  def set_case
    # Try to find by case_number first (most common), then by access_token
    @case = Case.find_by(case_number: params[:id]) || Case.find_by(access_token: params[:id])
    
    unless @case
      redirect_to new_triage_case_path, alert: 'Case not found.'
    end
  end

  def check_case_access
    # Check if user is logged in (for future login integration)
    # if current_user && @case.belongs_to_user?(current_user)
    #   return # Allow access
    # end

    # Check if access token is provided in params
    if params[:access_token] == @case.access_token
      session["case_#{@case.id}_verified"] = true
      session["case_#{@case.id}_verified_at"] = Time.current
      session["case_#{@case.id}_verified_email"] = @case.email.downcase
      return
    end

    # Check if already verified in session
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
    # Check if user is an admin
    return true if admin_authenticated?
    
    # Check if access token is provided in params (case creator with access token)
    if params[:access_token] == @case.access_token
      return true
    end
    
    # Check if user is logged in via triage email and case belongs to that email
    if triage_user_logged_in? && triage_user_email.present?
      return true if @case.belongs_to_email?(triage_user_email)
    end
    
    # Check if already verified in session (via access code) and email matches
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

  helper_method :triage_user_email, :triage_user_logged_in?, :can_mark_solution_fixed?

end
