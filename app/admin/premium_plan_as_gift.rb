ActiveAdmin.register PremiumPlanAsGift do

  menu priority: 5

  filter :price
  filter :display_position
  filter :name
  filter :duration_in_months
  filter :currency

  permit_params :price, :display_position, :name, :duration_in_months, :currency

  action_item only: [:show] do
    link_to "Generate redeem code", generate_redeem_code_admin_premium_plan_as_gift_path(premium_plan_as_gift)
  end

  member_action :generate_redeem_code do
    premium_plan_as_gift = PremiumPlanAsGift.find(params[:id])
    redeem_code = RedeemCode.create(code: "NEWCODE", valid_from: Time.now, valid_to: 1.year.from_now, redeemable: premium_plan_as_gift, max_number_of_uses: 1)
    redirect_to edit_admin_redeem_code_path(redeem_code)
  end

end
