class Word < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :category

  has_many :answers
  has_many :questions
  has_many :lessons, through: :questions

  accepts_nested_attributes_for :answers,
    allow_destroy: true

  validates :content, presence: true, length: {maximum: Settings.size_content}
  validate :validate_count_answers
  validate :just_one_answer_true
  validates_presence_of :answers

  filter_byword_learned = "id in (select questions.word_id from lessons
    join questions on lessons.id = questions.lesson_id
    where lessons.user_id = ? and lessons.category_id
    in (?) and questions.word_id is not null)"
  filter_byword_unlearned = "id not in (select questions.word_id from lessons
    join questions on lessons.id = questions.lesson_id
    where lessons.user_id = ? and questions.word_id is not null)
    and category_id in (?)"
  filter_by_word_all = "id in (select id from words
    where words.category_id in (?))"

  scope :random_index, ->{order "RANDOM()"}
  scope :by_learned,-> (user_id, category_id) do
    with_deleted.where filter_byword_learned, user_id, category_id
  end

  scope :by_unlearned, ->(user_id, category_id) do
    where filter_byword_unlearned, user_id, category_id
  end

  scope :by_all, ->(user_id, category_id) do
    without_deleted.where filter_by_word_all, category_id
  end

  private

  def just_one_answer_true
    if self.answers.select {|answer| answer.is_correct == true}.size !=
      Settings.true_size_answers
      errors.add :base, I18n.t("errors_answers")
    end
  end

  def validate_count_answers
    if answers.size > Settings.max_answers || answers.size <Settings.min_answers
      errors.add :base, I18n.t("error_size_answers")
    end
  end
end
