class Activity < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true  
  validates :target_id, presence: true
  validates :action, presence: true, length: { maximum: 40 }  
end
