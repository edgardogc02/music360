ActiveAdmin.register DiscountCode do

  menu priority: 3

  filter :code
  filter :valid_from
  filter :valid_to
  filter :discount_price
  filter :discount_percentage

  permit_params :code, :valid_from, :valid_to, :discount_price, :discount_percentage

  action_item only: [:new, :edit] do
    link_to "Generate random code", "#", {id: "generate_discount_code"}
  end

  form do |f|
    f.inputs "Details" do
      f.input :code
      f.input :discount_price
      f.input :discount_percentage
      f.input :valid_from, as: :datepicker
      f.input :valid_to, as: :datepicker
    end
    f.actions
  end

end
