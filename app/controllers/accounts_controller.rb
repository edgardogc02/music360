class AccountsController < ApplicationController
	before_action :authorize
	before_action :set_user, :get_subscription

  def overview
  	render layout: "detail"
  end

  def profile
  	render layout: "detail"
  end

  def subscription
  	render layout: "detail"
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def get_subscription
    @subscription = UserPremiumSubscription.find_by user_id: @user.id
  end
end
