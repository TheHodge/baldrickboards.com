class Admin::TriageCasesController < Admin::BaseController
  before_action :set_case, only: [:show, :update, :destroy, :update_status, :mark_spam, :force_solution, :add_comment]

  def index
    @cases = Case.includes(:solutions, :solved_by_solution)
                  .order(created_at: :desc)
    
    # Filter by status if specified
    if params[:status].present?
      @cases = @cases.where(status: params[:status])
    end
    
    # Filter by spam if specified
    if params[:spam].present?
      @cases = params[:spam] == 'true' ? @cases.spam : @cases.not_spam
    end
    
    # Statistics
    @total_cases = Case.count
    @open_cases = Case.open.count
    @solved_cases = Case.solved.count
    @closed_cases = Case.closed.count
    @new_cases_today = Case.where(created_at: Date.current.all_day).count
    @spam_cases = Case.spam.count
  end

  def show
    @solutions = @case.solutions.includes(:case_solutions)
                      .order('case_solutions.match_score DESC')
    # Get all active solutions for force solution dropdown
    @all_solutions = Solution.where(active: true).order(:problem_title)
    # Load comments for display
    @case.case_comments.load
  end

  def update
    if @case.update(case_params)
      redirect_to admin_triage_case_path(@case), notice: 'Case updated successfully.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_status
    new_status = params[:status]
    
    if %w[open solved closed].include?(new_status)
      @case.update(status: new_status)
      redirect_to admin_triage_case_path(@case), notice: "Case status updated to #{new_status}."
    else
      redirect_to admin_triage_case_path(@case), alert: 'Invalid status.'
    end
  end

  def mark_spam
    spam_value = params[:spam] == 'true'
    
    # Use update_column to bypass validations since we're only updating the spam field
    @case.update_column(:spam, spam_value)
    @case.reload
    
    if spam_value
      redirect_to admin_triage_case_path(@case), notice: 'Case marked as spam and hidden from public views.'
    else
      redirect_to admin_triage_case_path(@case), notice: 'Case unmarked as spam and visible in public views.'
    end
  end

  def add_comment
    comment = @case.case_comments.build(
      content: params[:content],
      admin_name: params[:admin_name]
    )
    
    if comment.save
      # Send email to the user
      TriageMailer.admin_comment(@case, comment).deliver_later
      redirect_to admin_triage_case_path(@case), notice: 'Comment added and email sent to user.'
    else
      redirect_to admin_triage_case_path(@case), alert: "Failed to add comment: #{comment.errors.full_messages.join(', ')}"
    end
  end

  def force_solution
    solution_id = params[:solution_id]
    custom_solution = params[:custom_solution]&.strip
    
    if solution_id.present?
      solution = Solution.find_by(id: solution_id)
      unless solution
        redirect_to admin_triage_case_path(@case), alert: 'Solution not found.'
        return
      end
      @case.mark_as_solved!(solution.id, nil)
      redirect_to admin_triage_case_path(@case), notice: "Case marked as solved with solution: #{solution.problem_title}"
    elsif custom_solution.present?
      @case.mark_as_solved!(nil, custom_solution)
      redirect_to admin_triage_case_path(@case), notice: 'Case marked as solved with custom solution.'
    else
      redirect_to admin_triage_case_path(@case), alert: 'Please select a solution or provide a custom solution.'
    end
  end

  def destroy
    @case.destroy
    redirect_to admin_triage_cases_path, notice: 'Case deleted successfully.'
  end

  private

  def set_case
    # Find by ID or case_number (for easier navigation)
    @case = Case.find_by(id: params[:id]) || Case.find_by(case_number: params[:id])
    unless @case
      redirect_to admin_triage_cases_path, alert: 'Case not found.'
    end
  end

  def case_params
    params.require(:case).permit(
      :name,
      :email,
      :problem_description,
      :tried_solutions,
      :knowledge_level,
      :status,
      :baldrick_version,
      :fpp_version,
      :xlights_version,
      :operating_system,
      :system_state,
      :fpp_outputs_state,
      :spam,
      affected_boards: []
    )
  end
end
