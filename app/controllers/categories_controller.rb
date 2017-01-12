class CategoriesController < ApplicationController
  before_action :admin_user, except: [:show, :index]
  before_action :logged_in_user
  before_action :load_category, except: [:create, :new, :index]
  before_action :delete_questions_if_exit

  def new
    @category = Category.new
  end

  def index
    @categories = Category.all
    if params[:search]
      @categories = Category.search(params[:search]).alpha.
        paginate page: params[:page], per_page: Settings.per_page
    else
      @categories = Category.alpha.paginate page: params[:page],
        per_page: Settings.per_page
    end
    @lesson = Lesson.new
  end

  def show
    @words = @category.words.paginate page: params[:page],
      per_page: Settings.per_page_words
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "created_success"
      redirect_to categories_path
    else
      flash[:danger] = t "create_fail"
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "updated_success"
      redirect_to categories_path
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "deleted_success"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to categories_url
  end

  private

  def category_params
    params.require(:category).permit :name, :discription
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = t "please_login_user_admin"
      redirect_to root_url
    end
  end

  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t "error_load"
      redirect_to categories_url
    end
  end
end
