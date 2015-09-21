class Goal < ActiveRecord::Base
  validates :title, :user_id, :goal_type, presence: true
  validates :goal_type, inclusion: { in: ["Private","Public"] }

  belongs_to :user

end
