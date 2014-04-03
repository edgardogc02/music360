class UserSentFacebookInvitation < ActiveRecord::Base

 validates :user_id, presence: true
 validates :user_facebook_id, presence: true

 belongs_to :user

end
