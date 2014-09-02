class PostComment < ActiveRecord::Base

  validates :user_id, presence: true
  validates :comment, presence: true

  belongs_to :commentable, polymorphic: true

  belongs_to :user

end
