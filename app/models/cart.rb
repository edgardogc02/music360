class Cart < ActiveRecord::Base

  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :songs, through: :line_items, source: :buyable, source_type: 'Song'
  has_many :premium_plans, through: :line_items, source: :buyable, source_type: 'PremiumPlan'
  belongs_to :discount_code

  attr_accessor :discount_code_code

  before_update :assign_discount_code_if_available

  def add_song(song_id)
    add_buyable(Song.find(song_id))
  end

  def add_premium_plan(premium_plan_id)
    add_buyable(PremiumPlan.find(premium_plan_id))
  end

  def subtotal
    @subtotal ||= line_items.to_a.sum{|item| item.total_price}
  end

  def total_price
    @total_price ||= subtotal + taxes - discount_price
  end

  def discount_price
    discount_code ? discount_code.discount_price : 0
  end

  def taxes
    2
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
    if discount_code_code
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
