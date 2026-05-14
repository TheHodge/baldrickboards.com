class Admin::WikiPagesController < Admin::BaseController
  before_action :set_wiki_sidebar, only: [:index, :show, :new, :create, :edit, :update, :formatting_guide]
  before_action :set_wiki_page, only: [:show, :edit, :update, :destroy]

  def index
  end

  def formatting_guide
  end

  def show
  end

  def new
    @wiki_page = if params[:missing_wiki_target].present?
      WikiPage.new_from_missing_wiki_target(params[:missing_wiki_target])
    else
      WikiPage.new(parent_id: params[:parent_id])
    end
    @prefilled_missing_wiki_target = WikiPage.sanitize_missing_wiki_target_param(params[:missing_wiki_target]) if params[:missing_wiki_target].present?
  end

  def create
    @wiki_page = WikiPage.new(wiki_page_params)

    if @wiki_page.save
      redirect_to admin_wiki_page_path(wiki_path: @wiki_page.url_path), notice: "Page created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @wiki_page.update(wiki_page_params)
      redirect_to admin_wiki_page_path(wiki_path: @wiki_page.url_path), notice: "Page updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wiki_page.destroy
    redirect_to admin_wiki_pages_path, notice: "Page deleted."
  end

  private

  def set_wiki_sidebar
    @wiki_nav_by_parent, @wiki_nav_roots = WikiPage.sidebar_tree
  end

  def set_wiki_page
    path = params[:wiki_path].to_s
    @wiki_page = WikiPage.find_by_url_path(path)
    @wiki_page ||= WikiPage.find_by(id: path) if path.match?(/\A\d+\z/)
    return if @wiki_page

    redirect_to admin_wiki_pages_path, alert: "That knowledge page could not be found."
  end

  def wiki_page_params
    params.require(:wiki_page).permit(:title, :parent_id, :position, :body)
  end
end
