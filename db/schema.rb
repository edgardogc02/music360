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

ActiveRecord::Schema.define(version: 20141202161856) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "challenge_id"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "activity_comments", force: true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
  end

  create_table "activity_likes", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
  end

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
    t.string   "imagename"
    t.integer  "created_by"
    t.boolean  "top"
    t.string   "bio_read_more_link"
    t.string   "cover"
    t.integer  "user_id"
    t.string   "twitter"
  end

  add_index "artists", ["slug"], name: "index_artists_on_slug", unique: true, using: :btree

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "discount_code_id"
    t.boolean  "mark_as_gift"
  end

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenge_posts", force: true do |t|
    t.integer  "challenge_id"
    t.integer  "publisher_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", force: true do |t|
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
    t.integer  "group_id"
    t.datetime "end_at"
    t.boolean  "open"
    t.datetime "start_at"
    t.text     "description"
  end

  create_table "discount_codes", force: true do |t|
    t.string   "code"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "discount_price"
    t.integer  "discount_percentage"
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

  create_table "group_invitations", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inviter_user_id"
    t.boolean  "pending_approval"
  end

  create_table "group_posts", force: true do |t|
    t.integer  "group_id"
    t.integer  "publisher_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_privacies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "initiator_user_id"
    t.integer  "group_privacy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "imagename"
    t.string   "created_by"
    t.text     "description"
    t.string   "cover"
  end

  create_table "instruments", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "visible"
    t.string   "created_by"
  end

  create_table "levels", force: true do |t|
    t.string   "title"
    t.integer  "xp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
  end

  create_table "line_items", force: true do |t|
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "buyable_id"
    t.string   "buyable_type"
    t.integer  "payment_id"
  end

  create_table "payment_methods", force: true do |t|
    t.string   "name"
    t.integer  "display_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "html_id"
  end

  create_table "payments", force: true do |t|
    t.float    "amount"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "paymill_token"
    t.string   "currency"
    t.integer  "payment_method_id"
    t.boolean  "gift"
    t.integer  "discount_code_id"
  end

  create_table "premium_plan_as_gifts", force: true do |t|
    t.float    "price"
    t.integer  "display_position"
    t.string   "name"
    t.integer  "duration_in_months"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "premium_plans", force: true do |t|
    t.float    "price"
    t.integer  "display_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "paymill_id"
    t.integer  "duration_in_months"
    t.string   "currency"
  end

  create_table "redeem_codes", force: true do |t|
    t.string   "code"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redeemable_id"
    t.string   "redeemable_type"
    t.integer  "max_number_of_uses"
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
    t.boolean  "user_created"
    t.string   "midi"
    t.integer  "uploader_user_id"
    t.string   "artist"
    t.string   "copyright"
    t.boolean  "premium"
    t.boolean  "display_feature"
  end

  add_index "songs", ["slug"], name: "index_songs_on_slug", using: :btree

  create_table "songscore", force: true do |t|
    t.string   "song"
    t.integer  "song_id"
    t.string   "user"
    t.integer  "user_id"
    t.integer  "score"
    t.integer  "instrument"
    t.string   "filename"
    t.date     "date"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "challenge_id"
  end

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

  create_table "user_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_invitations", force: true do |t|
    t.integer  "user_id"
    t.string   "friend_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_level_upgrades", force: true do |t|
    t.integer  "user_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_mp_updates", force: true do |t|
    t.integer  "user_id"
    t.integer  "mp"
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

  create_table "user_posts", force: true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_premium_subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "premium_plan_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paymill_subscription_token"
    t.integer  "payment_id"
  end

  create_table "user_purchased_songs", force: true do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "payment_id"
  end

  create_table "user_redeem_codes", force: true do |t|
    t.integer  "user_id"
    t.integer  "redeem_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", primary_key: "id_user", force: true do |t|
    t.string   "password_digest"
    t.string   "name",                     limit: 128
    t.string   "email",                    limit: 164
    t.string   "phone_number",             limit: 16
    t.string   "username",                 limit: 164
    t.string   "password",                 limit: 32
    t.string   "city",                     limit: 50
    t.string   "countrycode",              limit: 3
    t.string   "macaddress",               limit: 40
    t.string   "productkey",               limit: 36
    t.string   "confirmcode",              limit: 100
    t.string   "invitebyuser",             limit: 80
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
    t.integer  "challenges_count"
    t.integer  "first_song_id"
    t.integer  "first_challenge_id"
    t.integer  "xp"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "cover"
    t.datetime "installed_desktop_app_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree

  create_table "wishlist_items", force: true do |t|
    t.integer  "wishlist_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wishlists", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
