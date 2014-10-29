class Wishlist < ActiveRecord::Base

  belongs_to :user
  has_many :wishlist_items
  has_many :songs, through: :wishlist_items

end
