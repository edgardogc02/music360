class Payment < ActiveRecord::Base

  belongs_to :user
  belongs_to :payment_method
  belongs_to :discount_code

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

  def subtotal
    @subtotal ||= line_items.to_a.sum{|item| item.total_price}
  end

  def total_price
    @total_price ||= subtotal - discount_price
  end

  def discount_price
    if discount_code
      if discount_code.discount_price
        discount_code.discount_price
      elsif discount_code.discount_percentage
        discount_code.discount_percentage*subtotal/100
      else
        0
      end
    else
      0
    end
  end

  def taxes
    res = 0

    line_items.each do |line_item|
      if line_item.has_song?
        res += line_item.buyable.cost*6/100
      elsif line_item.has_premium_plan_as_gift?
        res += line_item.buyable.cost*25/100
      end
    end

    res
  end

end
