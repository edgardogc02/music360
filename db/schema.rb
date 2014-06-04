# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140604075156) do

  create_table "apps", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", force: true do |t|
    t.string   "title"
    t.text     "bio"
    t.string   "country"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artists", ["slug"], name: "index_artists_on_slug", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", primary_key: "challenge_id", force: true do |t|
    t.integer  "song_id",                       null: false
    t.boolean  "public",        default: false, null: false
    t.string   "challenger_id",                 null: false
    t.string   "challenged_id"
    t.integer  "instrument",                    null: false
    t.integer  "score_u1"
    t.integer  "score_u2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "instrument_u1"
    t.integer  "instrument_u2"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "instruments", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "visible"
    t.string   "created_by"
  end

  create_table "payment_types", force: true do |t|
    t.string   "name"
    t.integer  "display_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "html_id"
  end

  create_table "payments", force: true do |t|
    t.float    "payment_amount"
    t.string   "payment_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "payment_type_id"
    t.string   "paymill_token"
  end

  create_table "songratings", force: true do |t|
    t.integer  "song_id",    null: false
    t.integer  "user_id",    null: false
    t.integer  "rating",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "songratings", ["song_id"], name: "index_songratings_on_song_id", using: :btree
  add_index "songratings", ["user_id"], name: "index_songratings_on_user_id", using: :btree

  create_table "songs", force: true do |t|
    t.integer  "category_id"
    t.integer  "artist_id"
    t.string   "title"
    t.string   "cover"
    t.string   "length"
    t.integer  "difficulty"
    t.string   "comment"
    t.string   "status"
    t.boolean  "onclient"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "writer"
    t.integer  "arranger_userid"
    t.datetime "published_at"
    t.string   "publisher"
    t.float    "cost"
    t.string   "slug"
    t.string   "created_by"
    t.boolean  "visible"
  end

  add_index "songs", ["slug"], name: "index_songs_on_slug", using: :btree

  create_table "user_categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_facebook_friends", force: true do |t|
    t.integer  "user_id"
    t.integer  "user_facebook_friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_facebook_friends", ["user_facebook_friend_id"], name: "index_user_facebook_friends_on_user_facebook_friend_id", using: :btree
  add_index "user_facebook_friends", ["user_id"], name: "index_user_facebook_friends_on_user_id", using: :btree

  create_table "user_facebook_invitations", force: true do |t|
    t.integer  "user_id"
    t.string   "facebook_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_followers", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "follower_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_followers", ["follower_id"], name: "index_user_followers_on_follower_id", using: :btree
  add_index "user_followers", ["user_id", "follower_id"], name: "index_user_followers_on_user_id_and_follower_id", unique: true, using: :btree
  add_index "user_followers", ["user_id"], name: "index_user_followers_on_user_id", using: :btree

  create_table "user_invitations", force: true do |t|
    t.integer  "user_id"
    t.string   "friend_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_omniauth_credentials", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "oauth_uid"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_token_secret"
  end

  create_table "user_paid_songs", force: true do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "users", primary_key: "id_user", force: true do |t|
    t.string   "password_digest"
    t.string   "name",                  limit: 128
    t.string   "email",                 limit: 164
    t.string   "phone_number",          limit: 16
    t.string   "username",              limit: 164
    t.string   "password",              limit: 32
    t.string   "city",                  limit: 50
    t.string   "countrycode",           limit: 3
    t.string   "macaddress",            limit: 40
    t.string   "productkey",            limit: 36
    t.string   "confirmcode",           limit: 100
    t.string   "invitebyuser",          limit: 80
    t.datetime "confirmed"
    t.datetime "converted"
    t.string   "imagename"
    t.string   "timediff"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "careerpoints"
    t.string   "oauth_uid"
    t.integer  "user_category_id"
    t.string   "ip"
    t.integer  "instrument_id"
    t.boolean  "installed_desktop_app"
    t.boolean  "premium"
    t.datetime "premium_until"
    t.boolean  "updated_image"
    t.boolean  "admin"
    t.datetime "createdtime"
    t.string   "locale"
    t.string   "created_by"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree

end
