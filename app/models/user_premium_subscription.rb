class UserPremiumSubscription < ActiveRecord::Base

  validates :user_id, presence: true
#  validates :payment_id, presence: true
  validates :premium_plan_id, presence: true

  belongs_to :user
  belongs_to :payment
  belongs_to :premium_plan

  extend FriendlyId

  friendly_id :token

  scope :about_to_expire_in_hours, ->(hrs) { joins(:user).where('users.premium_until <= ?', hrs.hours.from_now) }

end
