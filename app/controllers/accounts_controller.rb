class AccountsController < ApplicationController
	before_action :authorize
	before_action :set_user

  def overview
    @user = User.find(current_user.id)
  end

  def profile
  end
  
  def subscription
  end
  
  def set_user
    @user = User.find(current_user.id)
  end
end
