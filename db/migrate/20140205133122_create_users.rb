class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, primary_key: "id_user" do |t|
      t.string :avatar_url
      t.string :level
      t.string :password_digest

      t.belongs_to :people_category

      t.string   "name",         limit: 128
      t.string   "email",        limit: 164
      t.string   "phone_number", limit: 16
      t.string   "username",     limit: 164
      t.string   "password",     limit: 32
      t.string   "city",         limit: 50
      t.string   "countrycode",  limit: 3
      t.string   "macaddress",   limit: 40
      t.string   "productkey",   limit: 36
      t.string   "confirmcode",  limit: 100
      t.string   "invitebyuser", limit: 80
      t.datetime "confirmed"
      t.datetime "converted"
      t.string   "imagename"
      t.string   "timediff"
      t.string   "comment"

      t.timestamps
    end
  end
end
