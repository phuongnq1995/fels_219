module ApplicationHelper

  def full_title page_title
    base_title = t "e_learning"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def link_to_remove_fields name, f
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for association, new_object,
      child_index: "new_#{association}" do |builder|
      render association.to_s.singularize + "_fields", f: builder
    end
    link_to_function name, "add_fields(this, \"#{association}\",
      \"#{escape_javascript(fields)}\")"
  end

  def index_of_result index
    index + 1
  end

  def time_of_lesson lesson
    lesson.questions.size * 20
  end

  def activity_of_action activity
    case activity.action
    when Settings.start
      @cat = Category.find_by(id: activity.target_id)
      return processed unless @cat
      link_to Category.find_by(id: activity.target_id).name
    when Settings.learned
      Word.find_by(id: activity.target_id).content
    else
    @user = User.find_by(id: activity.target_id).name
      return processed unless @user
      link_to User.find_by(id: activity.target_id).name
    end
  end

  private
  def processed
    flash[:alert] = t "fails"
    redirect_to @user
  end
end
