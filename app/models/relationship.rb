class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  before_create :activity_follow
  before_destroy :activity_unfollow

  private

  def activity_follow
    Activity.create user: follower, target_id: followed.id,
      action: Settings.follow
  end

  def activity_unfollow
    Activity.create user: follower, target_id: followed.id,
      action: Settings.unfollow
  end
end
