class Cart < ActiveRecord::Base

  belongs_to :user
  has_many :line_items, dependent: :destroy

  def add_song(song_id)
    current_item = line_items.find_by(song_id: song_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(song_id: song_id)
    end

    current_item
  end

  def total_price
    @total_price ||= line_items.to_a.sum{|item| item.total_price}
  end

end
