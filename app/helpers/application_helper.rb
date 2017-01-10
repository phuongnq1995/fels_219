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

  def number_words_of_category category
    category.words.size - 1
  end
end
