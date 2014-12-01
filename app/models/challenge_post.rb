class ChallengePost < ActiveRecord::Base

  include PublicActivity::Common

  validates :challenge_id, presence: true
  validates :publisher_id, presence: true
  validates :message, presence: true

  belongs_to :challenge
  belongs_to :publisher, class_name: 'User', foreign_key: 'publisher_id'

  auto_html_for :message do
    html_escape
    image
    youtube(:width => 400, :height => 250, :autoplay => false)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

end
