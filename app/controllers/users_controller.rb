class UsersController < ApplicationController
  def index
    @users = User.paginate page: params[:page], per: Settings.per_page
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

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t"let_login"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to(root_url) unless current_user? @user
  end
end
