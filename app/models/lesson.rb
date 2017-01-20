class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  has_many :questions, dependent: :destroy
  has_many :words, through: :questions
  has_many :answers, through: :questions

  accepts_nested_attributes_for :questions

  validates :user, presence: true
  validates :category, presence: true

  before_create :lesson_questions
  before_create :create_lesson

  def lesson_questions
    self.category.words.by_unlearned(self.user_id, self.category_id).
      random_index.limit(Settings.limit_number_word).each do |word|
        self.questions.build word_id: word.id, user_id: user_id
    end
  end

  def create_lesson
    Activity.create user: self.user, target_id: self.category_id,
      action: Settings.start
  end
end
