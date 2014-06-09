class PremiumPlan < ActiveRecord::Base

  has_many :user_premium_subscriptions

end
