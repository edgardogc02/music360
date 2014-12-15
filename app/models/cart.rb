class Cart < ActiveRecord::Base

  belongs_to :user
  has_many :line_items
  has_many :songs, through: :line_items, source: :buyable, source_type: 'Song'
  has_many :premium_plans, through: :line_items, source: :buyable, source_type: 'PremiumPlan'
  belongs_to :discount_code

  attr_accessor :discount_code_code

  before_update :assign_discount_code_if_available

  def add_song(song_id)
    add_buyable(Song.find(song_id))
  end

  def add_premium_plan_as_gift(premium_plan_as_gift_id)
    add_buyable(PremiumPlanAsGift.find(premium_plan_as_gift_id))
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

  def assign_payment(payment)
    line_items.each do |line_item|
      line_item.payment = payment
      line_item.save
    end
  end

  private

  def add_buyable(buyable)
    current_item = line_items.where(buyable: buyable).first
    if !current_item
      current_item = line_items.build(buyable: buyable)
    end

    current_item
  end

  def assign_discount_code_if_available
    if !discount_code_code.blank?
      discount_code_code.strip!
      discount_code = DiscountCode.where(code: discount_code_code).first

      if discount_code
        if discount_code.still_valid?
          self.discount_code_id = discount_code.id
        else
          errors.add :discount_code_id, "The discount code has already expired"
          false
        end
      else
        errors.add :discount_code_id, "The discount code is not valid"
        false
      end
    end
  end

end
