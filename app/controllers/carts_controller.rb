class CartsController < InheritedResources::Base

  before_action :authorize, except: [:show]

  def show
    @cart = current_user.current_cart
  end


end
