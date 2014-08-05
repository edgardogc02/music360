class AccountsController < ApplicationController
	before_action :authorize
	before_action :set_user

  def overview
  end

  def profile
  end
  
  def subscription
    @subscription = UserPremiumSubscription.find_by user_id: @user.id
  end
  
  def set_user
    @user = User.find(current_user.id)
  end
end
