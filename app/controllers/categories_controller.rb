class CategoriesController < ApplicationController
  before_action :logged_in_user
  skip_before_action :admin_user, only: :index
  skip_before_action :load_category, only: :index

  def index
    @categories = Category.newest.paginate page: params[:page], per: Settings.per_page
    @category = Category.new
    @lesson = Lesson.new
  end

  def show
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "created_success"
      redirect_to @category
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "updated_success"
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "deleted_success"
    else
      flash[:danger] = t "delete_fails"
    end
    redirect_to categories_url
  end

  private

  def category_params
    params.require(:category).permit :name, :discription
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t "error_load"
      redirect_to categories_url
    end
  end
end
