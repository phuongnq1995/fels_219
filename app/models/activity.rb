class Activity < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :target, presence: true
  validates :action, presence: true, length: {maximum: Settings.size_content}
end
