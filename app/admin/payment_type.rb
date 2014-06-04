ActiveAdmin.register PaymentType do

  menu false

  filter :name
  filter :created_at

  permit_params :name, :display_position, :html_id, :on, :model

  index do
    selectable_column
    column :id
    column :name
    column :display_position
    column :html_id
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :display_position
      f.input :html_id
    end
    f.actions
  end
end
