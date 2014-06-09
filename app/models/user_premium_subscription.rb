class UserPremiumSubscription < ActiveRecord::Base

  validates :user_id, presence: true
  validates :payment_type_id, presence: true
  validates :premium_plan_id, presence: true

  belongs_to :user
  belongs_to :payment_type
  belongs_to :premium_plan

  extend FriendlyId

  friendly_id :token

end
