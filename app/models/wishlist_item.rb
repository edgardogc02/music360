class WishlistItem < ActiveRecord::Base

  belongs_to :song
  belongs_to :wishlist

end
