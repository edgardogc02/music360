class WishlistsController < ApplicationController

  before_action :authorize

  def show
    @wishlist = Wishlist.find params[:id]
  end

end
