class Admin::TriageCasesController < Admin::BaseController
  before_action :set_case, only: [:show, :update, :destroy, :update_status]

  def index
    @cases = Case.includes(:solutions, :solved_by_solution)
                  .order(created_at: :desc)
    
    # Filter by status if specified
    if params[:status].present?
      @cases = @cases.where(status: params[:status])
    end
    
    # Statistics
    @total_cases = Case.count
    @open_cases = Case.open.count
    @solved_cases = Case.solved.count
    @closed_cases = Case.closed.count
    @new_cases_today = Case.where(created_at: Date.current.all_day).count
  end

  def show
    @solutions = @case.solutions.includes(:case_solutions)
                      .order('case_solutions.match_score DESC')
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

  def destroy
    @case.destroy
    redirect_to admin_triage_cases_path, notice: 'Case deleted successfully.'
  end

  private

  def set_case
    @case = Case.find(params[:id])
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
      affected_boards: []
    )
  end
end
