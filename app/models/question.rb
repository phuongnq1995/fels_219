class Question < ActiveRecord::Base
  belongs_to :word
  belongs_to :lesson
  belongs_to :user
  belongs_to :answer
end
