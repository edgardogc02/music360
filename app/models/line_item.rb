class LineItem < ActiveRecord::Base

  belongs_to :cart
  belongs_to :buyable, polymorphic: true

  def total_price
    buyable.cost
  end

end
