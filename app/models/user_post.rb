class UserPost < ActiveRecord::Base

  include PublicActivity::Common

  belongs_to :user

  has_many :likes, class_name: 'PostLike', as: :likeable
  has_many :likers, through: :likes, source: :user

  has_many :comments, class_name: 'PostComment', as: :commentable

  public

  def liked_by?(user)
    likers.include?(user)
  end

end
