class Payment < ActiveRecord::Base

  belongs_to :user
  belongs_to :payment_method

  has_many :user_premium_subscriptions
  has_many :user_purchased_songs
  has_many :line_items
  has_many :redeem_codes, as: :redeemable

  def has_premium_plan_as_gift?
    line_items.select{|l| l.has_premium_plan_as_gift?}.count > 0
  end

  def premium_plan_as_gift
    line_items.select{|l| l.has_premium_plan_as_gift?}.first.buyable
  end

end
