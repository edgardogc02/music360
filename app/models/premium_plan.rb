class PremiumPlan < ActiveRecord::Base

  has_many :user_premium_subscriptions

  scope :default_order, -> { order('display_position ASC') }
  scope :one_month_plan, -> { where(duration_in_months: 1).first }

  def title
    name
  end

  def cost
    price
  end

end
