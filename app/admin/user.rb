ActiveAdmin.register User do

  menu priority: 1

  actions :all, except: [:destroy]

  filter :username
  filter :email
  filter :city
  filter :countrycode
  filter :countrycode
  filter :confirmed
  filter :ip
  filter :premium
  filter :admin
  filter :created_at

  permit_params :username, :email, :first_name, :last_name, :password, :password_confirmation, :imagename, :phone_number, :city, :countrycode, :macaddress, :confirmcode, :invitebyuser, :confirmed, :converted, :deleted, :deleted_at, :xp, :user_category, :ip, :instrument, :installed_desktop_app, :premium, :premium_until, :updated_image, :admin, :locale, :on, :model

  index do
    column :id
    column :username
    column :email
    column :first_name
    column :last_name
    column :phone_number
    column :city
    column :countrycode
    column :macaddress
    column :confirmed
    column :deleted
    column :xp
    column :ip
    column :installed_desktop_app
    column :premium
    column :premium_until
    column :updated_image
    column :admin
    column :locale
    column :created_at

    actions
  end

  form(html: { multipart: true }) do |f|
    f.inputs "Details" do
      f.input :email
      f.input :phone_number
      f.input :username
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :password_confirmation
      if !f.object.new_record?
        f.input :imagename, as: :file
      end
      f.input :city
      f.input :countrycode
      f.input :macaddress
      f.input :productkey
      f.input :confirmcode
      f.input :invitebyuser
      f.input :confirmed
      f.input :converted
      f.input :deleted
      f.input :deleted_at
      f.input :xp
      f.input :user_category
      f.input :ip
      f.input :instrument
      f.input :installed_desktop_app
      f.input :premium
      f.input :premium_until
      f.input :updated_image
      f.input :admin
      f.input :locale
    end
    f.actions
  end

end
