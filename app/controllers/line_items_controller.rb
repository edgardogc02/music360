class LineItemsController < ApplicationController

  before_action :authorize

  def create
    cart = current_user.current_cart
    @line_item = cart.add_song(params[:song_id]) if params[:song_id]
    @line_item = cart.add_premium_plan_as_gift(params[:premium_plan_as_gift_id]) if params[:premium_plan_as_gift_id]

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart, notice: "The item was added to your cart" }
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
    line_item = LineItem.find(params[:id])
    line_item.destroy
    redirect_to current_user.current_cart, notice: "The item was successfully removed from your cart"
  end

end
