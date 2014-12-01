class ActivityComment < ActiveRecord::Base

  validates :user_id, presence: true
  validates :comment, presence: true

  belongs_to :activity, class_name: 'PublicActivity::Activity'
  belongs_to :user

  auto_html_for :comment do
    html_escape
    image
    youtube(:width => 400, :height => 250, :autoplay => false)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

end
