class Goal < ActiveRecord::Base
  include Commentable
  validates :title, :user_id, :goal_type, presence: true
  validates :goal_type, inclusion: { in: ["Private","Public"] }

  belongs_to :user

  # has_many(
  #   :comments,
  #   as: :commentable
  # )

end
