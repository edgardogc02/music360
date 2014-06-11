ActiveAdmin.register PremiumPlan do

  menu false

  filter :price
  filter :display_position
  filter :created_at

  permit_params :price, :display_position, :name, :on, :model

end
