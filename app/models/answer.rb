class Answer < ActiveRecord::Base
  belongs_to :word

  has_many :questions
  has_many :lessons, through: :questions

  validates :content, presence: true, length: {maximum: Settings.size_content}
end
