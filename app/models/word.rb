class Word < ActiveRecord::Base
  belongs_to :category

  has_many :answers, dependent: :destroy
  has_many :questions
  has_many :lessons, through: :questions

  validates :content, presence: true, length: {maximum: Settings.size_content}
end
