class Payment < ActiveRecord::Base

  belongs_to :user
  belongs_to :payment_method

  has_many :user_premium_subscriptions

end
