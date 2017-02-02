class CategoriesController < ApplicationController

  before_action :require_admin, except: [:index, :show]

  def index
    @records = Category.page params[:page]
  end

  def new
    @record = Category.new
  end

  def create
    @record = Category.new(safe_params)
    if @record.save
      flash[:success] = "Category successfully created"
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
    @record = Category.find(params[:id])
  end

  def update
    @record = Category.find(params[:id])
    if @record.update(safe_params)
      flash[:success] = "Category successfully updated"
      redirect_to category_path(@record)
    else
      render :edit
    end
  end

  def show
    @record = Category.find(params[:id])
    @record_articles = @record.articles.page params[:page]
  end

private

  def safe_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_user.admin?)
      flash[:danger] = "Only admins can perform this action"
      redirect_to categories_path
    end
  end
end
