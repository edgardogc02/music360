class WishlistItemsController < ApplicationController

  before_action :authorize

  def create
    @wishlist_item = current_user.current_wishlist.wishlist_items.build(wishlist_item_params)

    respond_to do |format|
      if @wishlist_item.save
        format.html { redirect_to @wishlist_item.wishlist, notice: "The song was added to your wishlist" }
        format.js
      else
        format.html do
          flash[:warning] = "Something went wrong. Please try again"
          redirect_to songs_path
        end
        format.js
      end
    end
  end

  def destroy
    wishlist_item = WishlistItem.find(params[:id])
    wishlist_item.destroy
    redirect_to current_user.current_wishlist, notice: "The item was successfully removed from your wishlist"
  end

  private

  def wishlist_item_params
    params.require(:wishlist_item).permit(:song_id)
  end

end
