class Cart < ActiveRecord::Base

  belongs_to :user
  has_many :line_items, dependent: :destroy

  def add_song(song_id)
    add_buyable(Song.find(song_id))
  end

  def add_premium_plan(premium_plan_id)
    add_buyable(PremiumPlan.find(premium_plan_id))
  end

  def total_price
    @total_price ||= line_items.to_a.sum{|item| item.total_price}
  end

  private

  def add_buyable(buyable)
    current_item = line_items.where(buyable: buyable).first
    if !current_item
      current_item = line_items.build(buyable: buyable)
    end

    current_item
  end

end
