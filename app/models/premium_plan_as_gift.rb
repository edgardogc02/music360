class PremiumPlanAsGift < ActiveRecord::Base

  def title
    name
  end

  def cost
    price
  end

end
