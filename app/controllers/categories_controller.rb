class CategoriesController < ApplicationController
  before_action :admin_user, except: [:show, :index]
  before_action :logged_in_user
  before_action :load_category,
    except: [:new, :index, :create, :really_destroy, :restore]
  before_action :load_category_deleted, only: [:really_destroy, :restore]
  before_action :delete_questions_if_exit

  def new
    @category = Category.new
  end

  def index
    @categories = Category.search(params[:search]).alpha.
      paginate page: params[:page], per_page: Settings.per_page
    @lesson = Lesson.new
  end

  def show
    @words = @category.words.with_deleted.paginate page: params[:page],
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

  def really_destroy
    if @category.really_destroy!
      flash[:success] = t "deleted_success"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to categories_url
  end

  def restore
    @words = Word.only_deleted.where category_id: @category.id
    if @words
      Category.transaction do
        @category.restore
        @words.each do |word|
          if word.restore
          else
            raise ActiveRecord::Rollback, t("restore_fail")
          end
        end
          flash[:success] = t "restore_success"
      end
    else
      if @category.restore
        flash[:success] = t "restore_success"
      else
        flash[:danger] = t "restore_fail"
      end
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

  def load_category_deleted
    @category = Category.only_deleted.find_by id: params[:id]
    unless @category
      flash[:danger] = t "error_load"
      redirect_to categories_url
    end
  end
end
