class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :load_lesson, only: [:edit, :update, :show]
  before_action :load_category, only: [:edit, :update, :create]
  after_action :delete_answer_false, only: :show
  skip_before_action :delete_questions_if_exit, only: :create
  after_action :learned_words, only: :update

  def create
    @lesson = @category.lessons.build user: current_user
    if @lesson.save && @lesson.words.any?
      flash[:success] = t "started"
      redirect_to edit_category_lesson_path @category, @lesson
    else
      flash[:danger] = t "were_finished"
      redirect_to categories_path
    end
  end

  def edit
  end

  def update
    if @lesson.update_attributes questions_params
      flash[:success] = t "finish"
      redirect_to category_lesson_path @category, @lesson
    else
      render :edit
    end
  end

  def show
    @score = @lesson.questions.correct_anwsers.size
    @results = @lesson.questions.includes :word, :answer
  end

  private

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    unless @lesson
      flash[:danger] = t "error_load"
      redirect_to categories_path
    end
  end

  def load_category
    @category = Category.find_by id: params[:category_id]
    unless @category
      flash[:danger] = t "error_load"
      redirect_to categories_path
    end
  end

  def questions_params
    params.require(:lesson).permit :category_id,
      questions_attributes: [:id, :answer_id]
  end

  def delete_answer_false
    Question.fail_answers.delete_all
    Question.null_answers.delete_all
  end

  def learned_words
    @lesson.questions.correct_anwsers.each do |question|
      Activity.create user: question.user, target_id: question.word.id,
        action: Settings.learned
    end
  end
end
