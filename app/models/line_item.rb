class LineItem < ActiveRecord::Base

  belongs_to :song
  belongs_to :cart

  validates :song_id, presence: true

  def total_price
    quantity * song.cost
  end

end
