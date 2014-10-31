ActiveAdmin.register RedeemCode do

  menu priority: 4

  filter :code
  filter :valid_from
  filter :valid_to
  filter :max_number_of_uses

  permit_params :code, :valid_from, :valid_to, :max_number_of_uses

  action_item only: [:new, :edit] do
    link_to "Generate random code", "#", {id: "generate_code"}
  end

  form do |f|
    f.inputs "Details" do
      f.input :code, input_html: {id: "code"}
      f.input :max_number_of_uses
      f.fields_for :redeemable do |builder|
        builder.input :redeemable_id
        builder.input :redeemable_type
      end
      f.input :valid_from, as: :datepicker
      f.input :valid_to, as: :datepicker
    end
    f.actions
  end

end
