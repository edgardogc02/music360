class LineItem < ActiveRecord::Base

  belongs_to :cart
  belongs_to :buyable, polymorphic: true
  belongs_to :payment

  def total_price
    buyable.cost
  end

  def has_song?
    buyable.is_a?(Song)
  end

  def has_premium_plan_as_gift?
    buyable.is_a?(PremiumPlanAsGift)
  end

end
