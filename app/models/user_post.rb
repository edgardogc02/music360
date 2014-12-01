class UserPost < ActiveRecord::Base

  include PublicActivity::Common

  belongs_to :user

  has_many :likes, class_name: 'PostLike', as: :likeable
  has_many :likers, through: :likes, source: :user

#  has_many :comments, class_name: 'PostComment', as: :commentable

  public

  def liked_by?(user)
    likers.include?(user)
  end

  auto_html_for :message do
    html_escape
    image
    youtube(:width => 400, :height => 250, :autoplay => false)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

end
