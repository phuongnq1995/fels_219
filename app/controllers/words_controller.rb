class WordsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :load_category, only: :create
  skip_before_action :load_word, only: :create
  before_action :delete_lesson_if_dont_edit

  def create
    @word = @category.words.build word_params
    if @word.save
      flash[:success] = t "created_success"
    else
      flash[:danger] = t "create_fail"
    end
    redirect_to @category
  end

  def edit
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t "updated_success"
      redirect_to @word.category
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    if @word.destroy
      flash[:success] = t "deleted_success"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to @word.category
  end

  private

  def word_params
    params.require(:word).permit :content,
      answers_attributes: [:id, :content, :is_correct]
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = t "please_login_user_admin"
      redirect_to root_url
    end
  end

  def load_word
    @word = Word.find_by id: params[:id]
    unless @word
      flash[:danger] = t "error_load"
      redirect_to categories_url
    end
  end

  def load_category
    @category = Category.find_by id: params[:category_id]
    unless @category
      flash[:danger] = t "error_load"
      redirect_to categories_url
    end
  end
end
