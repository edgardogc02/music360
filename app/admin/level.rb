ActiveAdmin.register Level do

  menu priority: 4

  permit_params :title, :xp, :on, :model

  filter :title
  filter :xp
  filter :created_at

end
