class Admin::TriageSolutionsController < Admin::BaseController
  before_action :set_solution, only: [:show, :edit, :update, :destroy]

  def index
    @solutions = Solution.order(created_at: :desc)
    
    # Filter by active status if specified
    if params[:active].present?
      @solutions = @solutions.where(active: params[:active] == 'true')
    end
    
    # Statistics
    @total_solutions = Solution.count
    @active_solutions = Solution.active.count
    @inactive_solutions = Solution.inactive.count
  end

  def show
    @cases = @solution.cases.includes(:case_solutions)
                      .order('case_solutions.match_score DESC')
                      .limit(20)
  end

  def new
    @solution = Solution.new
  end

  def create
    @solution = Solution.new(solution_params)
    
    if @solution.save
      redirect_to admin_triage_solution_path(@solution), notice: 'Solution created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @solution.update(solution_params)
      redirect_to admin_triage_solution_path(@solution), notice: 'Solution updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @solution.destroy
    redirect_to admin_triage_solutions_path, notice: 'Solution deleted successfully.'
  end

  private

  def set_solution
    @solution = Solution.find(params[:id])
  end

  def solution_params
    permitted = params.require(:solution).permit(
      :problem_title,
      :solution_text,
      :active,
      :problem_keywords,
      board_types: []
    )
    
    # Handle problem_keywords - split by newlines if it's a string
    if permitted[:problem_keywords].is_a?(String)
      permitted[:problem_keywords] = permitted[:problem_keywords].split("\n").map(&:strip).reject(&:blank?)
    end
    
    permitted
  end
end
