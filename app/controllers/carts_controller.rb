class CartsController < ApplicationController

  before_action :authorize

  def show
    @cart = current_user.current_cart
  end


end
