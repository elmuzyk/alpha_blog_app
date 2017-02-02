class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @records = User.all
  end

  def new
    @record = User.new
  end

  def create
    @record = User.new(user_params)
    if @record.save
      session[:user_id] = @record.id #Signs in automatically after creating an account
      flash[:success] = "User sucessfully created"
      redirect_to user_path(@record)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @record.update(user_params)
      flash[:success] = "Acount successfully updated"
      redirect_to articles_path
    else
      render :edit
    end
  end

  def show
    @record_articles = @record.articles.page params[:page]
  end

  def destroy
    @record = User.find(params[:id])
    @record.destroy
    flash[:danger] = "User and all articles created by user have been destroyed"
    redirect_to users_path
  end

private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @record and !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admin users can perform that action"
      redirect_to root_path
    end
  end

  def set_user
    @record = User.find(params[:id])
  end


end
