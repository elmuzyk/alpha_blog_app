class ArticlesController < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @records = Article.page params[:page]
  end

  def new
    @record = Article.new
  end

  def edit
  end

  def update
    if @record.update(safe_params)
      flash[:notice] = "Article was successfully updated"
      redirect_to article_path(@record)
    else
      render 'edit'
    end
  end

  def create
    #render plain: params[:article].inspect
    @record = Article.new(safe_params)
    @record.user = current_user
    if @record.save
      flash[:notice] = "Article was successfully created"
      redirect_to article_path(@record)
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @record.destroy
    flash[:danger]= "Article was sucessfully deleted"
    redirect_to articles_path
  end


private

  def set_article
    @record = Article.find(params[:id])
  end

  def require_same_user
    if current_user != @record.user and !current_user.admin?
      flash[:danger] = "You can only edit your own articles"
      redirect_to root_path
    end
  end

  def safe_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end
end
