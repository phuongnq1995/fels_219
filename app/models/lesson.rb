class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  has_many :questions, dependent: :destroy
  has_many :words, through: :questions
  has_many :answers, through: :questions

  validates :user, presence: true
  validates :category, presence: true
end
