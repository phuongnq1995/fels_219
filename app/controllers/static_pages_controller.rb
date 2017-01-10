class StaticPagesController < ApplicationController
  before_action :delete_lesson_if_dont_edit

  def home
  end
end
