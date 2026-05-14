class Admin::WikiPagesController < Admin::BaseController
  before_action :set_wiki_sidebar, only: [:index, :show, :new, :create, :edit, :update]
  before_action :set_wiki_page, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @wiki_page = WikiPage.new(parent_id: params[:parent_id])
  end

  def create
    @wiki_page = WikiPage.new(wiki_page_params)

    if @wiki_page.save
      redirect_to admin_wiki_page_path(@wiki_page), notice: "Page created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @wiki_page.update(wiki_page_params)
      redirect_to admin_wiki_page_path(@wiki_page), notice: "Page updated."
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
    @wiki_page = WikiPage.find(params[:id])
  end

  def wiki_page_params
    params.require(:wiki_page).permit(:title, :parent_id, :position, :body)
  end
end
