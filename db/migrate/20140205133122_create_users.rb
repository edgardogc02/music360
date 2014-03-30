class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, primary_key: "id_user" do |t|
      t.string :username
      t.string :email
      t.string :avatar
      t.string :level
      t.string :password_digest

      t.belongs_to :people_category

      t.string    :name
      t.string    :city
      t.string    :countrycode
      t.string    :macaddress
      t.string    :productkey
      t.integer   :invitebyuser
      t.datetime  :confirmed_at
      t.datetime  :converted_at
      t.integer   :timezone
      t.string    :comment

      t.timestamps
    end
  end
end
