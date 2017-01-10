class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :redirect_incorrect_user, only: [:edit, :update]
  before_action :delete_lesson_if_dont_edit

  def index
    @users = User.recent.paginate page: params[:page],
      per_page: Settings.per_page_users
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    unless @user
      redirect_to root_url
      flash[:danger] = t "not_found"
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to root_url
      flash[:success] = t "welcome_to_app"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "user_invalid"
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :avatar
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "let_login"
      redirect_to login_url
    end
  end

  def redirect_incorrect_user
    redirect_to root_url unless current_user? @user
  end
end
