class PostLike < ActiveRecord::Base

  belongs_to :likeable, polymorphic: true

  belongs_to :user

  validate :user_should_like_same_post_just_once, on: :create

  public

  def self.by_user_and_likeable(user, likeable)
    PostLike.find_by(user: user, likeable: likeable)
  end

  private

  def user_should_like_same_post_just_once
    if self.user.post_likes.where(likeable_id: self.likeable_id, likeable_type: self.likeable_type).count > 0
      errors.add :user_id, "You already liked that post"
    end
  end

end
