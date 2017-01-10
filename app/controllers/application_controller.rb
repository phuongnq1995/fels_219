class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "please_log_in"
      redirect_to login_url
    end
  end

  def delete_lesson_if_dont_edit
    if logged_in?
      current_user.lessons.each do |lesson|
        lesson.questions.each do |question|
          if question.created_at == question.updated_at
            question.destroy
          end
        end
      end
    end
  end
end
