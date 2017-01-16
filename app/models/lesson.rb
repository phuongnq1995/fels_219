class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  has_many :questions
  has_many :words, through: :questions
  has_many :answers, through: :questions

  accepts_nested_attributes_for :questions

  validates :user, presence: true
  validates :category, presence: true

  before_create :lesson_questions

  def lesson_questions
    self.category.words.by_unlearned(self.user_id, self.category_id).
      random_index.limit(Settings.limit_number_word).each do |word|
        self.questions.build word_id: word.id, user_id: user_id
    end
  end
end
