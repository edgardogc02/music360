class LineItem < ActiveRecord::Base

  belongs_to :cart
  belongs_to :buyable, polymorphic: true

  def total_price
    buyable.cost
  end

  def has_song?
    buyable.is_a?(Song)
  end

  def has_premium_plan?
    buyable.is_a?(PremiumPlan)
  end

end
