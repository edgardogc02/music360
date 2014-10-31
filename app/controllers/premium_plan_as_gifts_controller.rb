class PremiumPlanAsGiftsController < ApplicationController
	before_action :authorize

  def index
    @premium_plan_as_gifts = PremiumPlanAsGift.order(:display_position)
  end

end
