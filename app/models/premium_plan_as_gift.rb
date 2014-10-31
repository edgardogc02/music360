class PremiumPlanAsGift < ActiveRecord::Base

  has_many :redeem_codes, as: :redeemable

  def title
    name
  end

  def cost
    price
  end

end
