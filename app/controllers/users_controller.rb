class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :redirect_incorrect_user, only: [:edit, :update]
  before_action :delete_questions_if_exit

  def index
    @users = User.recent.paginate page: params[:page],
      per_page: Settings.per_page_users
  end

  def new
    @user = User.new
  end

   def show
    @active_rls = @user.active_relationships.build
    @activity = @user.activities.paginate page: params[:page],
      per_page: Settings.per_page_activity
    end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
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

  def redirect_incorrect_user
    redirect_to root_url unless current_user? @user
  end
end
