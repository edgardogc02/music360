class PremiumPlan < ActiveRecord::Base

  has_many :user_premium_subscriptions

  scope :default_order, -> { order('display_position ASC') }

end
