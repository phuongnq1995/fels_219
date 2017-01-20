class StaticPagesController < ApplicationController
  before_action :delete_questions_if_exit

  def home
    if logged_in?
      @activity = Activity.feed(current_user).paginate page: params[:page],
        per_page: Settings.per_page_activity
    else
      @activity = Activity.recent.paginate page: params[:page],
        per_page: Settings.per_page_activity
    end
  end
end
