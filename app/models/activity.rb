class Activity < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :target_id, presence: true
  validates :action, presence: true, length: {maximum: Settings.size_content}

  scope :recent, -> {order created_at: :desc}

  follow_list = "user_id IN (SELECT followed_id FROM relationships
    WHERE  follower_id = :user_id) OR user_id = :user_id"

  scope :feed, -> user_id do
    where follow_list, user_id: user_id
  end
end
