class Comment < ActiveRecord::Base
  validates :body, :commentable_id, :commentable_type, :author_id, presence: true
  validates :commentable_type, inclusion: { in: ["User", "Goal"] }

  belongs_to :commentable, polymorphic: true

  belongs_to(
    :author,
    class_name: :User,
    primary_key: :id,
    foreign_key: :author_id
  )
end
