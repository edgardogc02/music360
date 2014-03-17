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

ActiveRecord::Schema.define(version: 20140224195540) do

  create_table "BETA installations", id: false, force: true do |t|
    t.datetime "installation completion date",             null: false
    t.string   "email",                        limit: 64,  null: false
    t.string   "comment",                      limit: 300, null: false
    t.string   "username",                     limit: 164
    t.string   "productkey",                   limit: 36,  null: false
    t.string   "country",                      limit: 3,   null: false
    t.string   "city",                         limit: 50,  null: false
  end

  create_table "BETA productkeys", id: false, force: true do |t|
    t.integer "id",                     null: false
    t.string  "productkey", limit: 36,  null: false
    t.string  "email",      limit: 64,  null: false
    t.string  "comment",    limit: 300, null: false
    t.string  "country",    limit: 3,   null: false
    t.string  "city",       limit: 50,  null: false
  end

  create_table "BETA song cancellations", id: false, force: true do |t|
    t.string  "email",         limit: 64,  null: false
    t.string  "comment",       limit: 300, null: false
    t.string  "username",      limit: 164
    t.string  "productkey",    limit: 36,  null: false
    t.date    "date",                      null: false
    t.string  "song",          limit: 100, null: false
    t.integer "score1",                    null: false
    t.integer "score2",                    null: false
    t.integer "score3",                    null: false
    t.integer "score4",                    null: false
    t.integer "p3_instrument",             null: false
  end

  create_table "BETA song playing", id: false, force: true do |t|
    t.string  "email",      limit: 64,  null: false
    t.string  "comment",    limit: 300, null: false
    t.string  "username",   limit: 164
    t.string  "productkey", limit: 36,  null: false
    t.date    "date",                   null: false
    t.string  "song",       limit: 100, null: false
    t.integer "score",                  null: false
    t.integer "instrument",             null: false
  end

  create_table "City", primary_key: "ID", force: true do |t|
    t.string "NR",          limit: 12,              null: false
    t.string "CountryCode", limit: 3,  default: "", null: false
    t.string "Country",     limit: 50,              null: false
    t.string "District",    limit: 20, default: "", null: false
    t.string "Name",        limit: 35,              null: false
    t.string "Latitude",    limit: 20,              null: false
    t.string "Longitude",   limit: 20,              null: false
  end

  add_index "City", ["Name"], name: "idx_name", unique: true, using: :btree

  create_table "CityBackup", primary_key: "ID", force: true do |t|
    t.string "NR",          limit: 12,              null: false
    t.string "CountryCode", limit: 3,  default: "", null: false
    t.string "Country",     limit: 50,              null: false
    t.string "District",    limit: 20, default: "", null: false
    t.string "Name",        limit: 35,              null: false
    t.string "Latitude",    limit: 20,              null: false
    t.string "Longitude",   limit: 20,              null: false
  end

  create_table "CityOld", primary_key: "ID", force: true do |t|
    t.string  "Name",        limit: 35, default: "", null: false
    t.string  "CountryCode", limit: 3,  default: "", null: false
    t.string  "District",    limit: 20, default: "", null: false
    t.integer "Population",             default: 0,  null: false
    t.string  "Latitude",    limit: 20,              null: false
    t.string  "Longitude",   limit: 20,              null: false
  end

  create_table "Country", primary_key: "Code", force: true do |t|
    t.string  "Name",           limit: 52, default: "",     null: false
    t.string  "Continent",      limit: 13, default: "Asia", null: false
    t.string  "Region",         limit: 26, default: "",     null: false
    t.float   "SurfaceArea",    limit: 10, default: 0.0,    null: false
    t.integer "IndepYear",      limit: 2
    t.integer "Population",                default: 0,      null: false
    t.float   "LifeExpectancy", limit: 3
    t.float   "GNP",            limit: 10
    t.float   "GNPOld",         limit: 10
    t.string  "LocalName",      limit: 45, default: "",     null: false
    t.string  "GovernmentForm", limit: 45, default: "",     null: false
    t.string  "HeadOfState",    limit: 60
    t.integer "Capital"
    t.string  "Code2",          limit: 2,  default: "",     null: false
  end

  create_table "cancelledsongs", force: true do |t|
    t.string  "song",          limit: 100, null: false
    t.string  "user",          limit: 100, null: false
    t.integer "score1",                    null: false
    t.integer "score2",                    null: false
    t.integer "score3",                    null: false
    t.integer "score4",                    null: false
    t.integer "p3_instrument",             null: false
    t.date    "date",                      null: false
  end

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", primary_key: "challenge_id", force: true do |t|
    t.string   "user1",      limit: 164, null: false
    t.string   "user2",      limit: 164, null: false
    t.string   "song",       limit: 164, null: false
    t.integer  "instrument",             null: false
    t.integer  "score_u1",               null: false
    t.integer  "score_u2",               null: false
    t.integer  "winner",                 null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "competitions", force: true do |t|
    t.string "song", limit: 100, null: false
    t.string "user", limit: 100, null: false
    t.date   "date",             null: false
  end

  create_table "convertion_log", force: true do |t|
    t.text     "description", limit: 16777215, null: false
    t.datetime "created",                      null: false
  end

  create_table "downloaders", primary_key: "id_user", force: true do |t|
    t.string "name",         limit: 128, null: false
    t.string "email",        limit: 64,  null: false
    t.string "phone_number", limit: 16,  null: false
    t.string "username",     limit: 32,  null: false
    t.string "password",     limit: 32,  null: false
    t.string "confirmcode",  limit: 32
    t.string "productkey",   limit: 36,  null: false
    t.string "city",         limit: 50,  null: false
    t.string "countrycode",  limit: 3
    t.string "macaddress",   limit: 40,  null: false
    t.string "comment",      limit: 500, null: false
    t.string "time",         limit: 25,  null: false
  end

  create_table "fbfriends", primary_key: "friendshipid", force: true do |t|
    t.string "username",   limit: 32, null: false
    t.string "fbusername", limit: 32, null: false
  end

  create_table "friends", primary_key: "friendshipid", force: true do |t|
    t.string "username",  limit: 164, null: false
    t.string "username2", limit: 164, null: false
  end

  create_table "ic_team_clients", id: false, force: true do |t|
    t.integer  "id_user",                 default: 0, null: false
    t.string   "comment",     limit: 400,             null: false
    t.string   "email",       limit: 164
    t.string   "productkey",  limit: 36,              null: false
    t.datetime "createdtime",                         null: false
    t.datetime "confirmed",                           null: false
    t.datetime "converted",                           null: false
    t.string   "macaddress",  limit: 40
  end

  create_table "installationkeys", force: true do |t|
    t.string "productkey", limit: 30,  null: false
    t.string "macaddress", limit: 40,  null: false
    t.string "country",    limit: 30,  null: false
    t.date   "date",                   null: false
    t.string "comment",    limit: 100, null: false
    t.string "user",       limit: 100, null: false
  end

  add_index "installationkeys", ["productkey"], name: "productkey", using: :btree

  create_table "loginlog", force: true do |t|
    t.string "comment", limit: 200, null: false
    t.date   "date",                null: false
    t.string "country", limit: 30,  null: false
  end

  create_table "payments", force: true do |t|
    t.string   "txnid",          limit: 20,                         null: false
    t.decimal  "payment_amount",            precision: 7, scale: 2, null: false
    t.string   "payment_status", limit: 25,                         null: false
    t.string   "item_name",      limit: 50,                         null: false
    t.string   "receiver_email", limit: 50,                         null: false
    t.string   "payer_email",    limit: 50,                         null: false
    t.string   "custom",         limit: 25,                         null: false
    t.string   "itemid",         limit: 25,                         null: false
    t.datetime "createdtime",                                       null: false
  end

  create_table "productkeys", force: true do |t|
    t.string  "productkey",          limit: 36,                null: false
    t.string  "status",              limit: 20,                null: false
    t.integer "type",                limit: 2,                 null: false
    t.string  "instrument",          limit: 6,   default: "0", null: false
    t.date    "date",                                          null: false
    t.string  "comment",             limit: 300,               null: false
    t.string  "country",             limit: 3,                 null: false
    t.string  "city",                limit: 50,                null: false
    t.string  "email",               limit: 64,                null: false
    t.string  "startsong",           limit: 100,               null: false
    t.string  "firstfriendusername", limit: 64,                null: false
    t.string  "startmessage",        limit: 100,               null: false
  end

  create_table "productkeyscount", primary_key: "usercount", force: true do |t|
  end

  create_table "songs", force: true do |t|
    t.string  "title",           limit: 100, null: false
    t.string  "writer",          limit: 100, null: false
    t.string  "artist",          limit: 100, null: false
    t.string  "length",          limit: 50,  null: false
    t.integer "difficulty",                  null: false
    t.integer "arranger_userid",             null: false
    t.string  "comment",         limit: 400, null: false
    t.string  "status",          limit: 16,  null: false
    t.boolean "onclient",                    null: false
  end

  create_table "songscore", force: true do |t|
    t.string  "song",       limit: 100, null: false
    t.string  "user",       limit: 100, null: false
    t.integer "score",                  null: false
    t.integer "instrument",             null: false
    t.date    "date",                   null: false
  end

  create_table "testing", force: true do |t|
    t.string "test", limit: 50, null: false
  end

  create_table "usercount", primary_key: "usercount", force: true do |t|
  end

  create_table "users", primary_key: "id_user", force: true do |t|
    t.string   "name",         limit: 128
    t.string   "email",        limit: 164
    t.string   "phone_number", limit: 16
    t.string   "username",     limit: 164
    t.string   "password",     limit: 32
    t.string   "city",         limit: 50
    t.string   "countrycode",  limit: 3
    t.string   "macaddress",   limit: 40
    t.string   "productkey",   limit: 36,  null: false
    t.string   "confirmcode",  limit: 100, null: false
    t.string   "invitebyuser", limit: 80,  null: false
    t.datetime "createdtime",              null: false
    t.datetime "confirmed",                null: false
    t.datetime "converted",                null: false
    t.string   "imagename",    limit: 100, null: false
    t.string   "timediff",     limit: 10,  null: false
    t.string   "comment",      limit: 400, null: false
  end

  create_table "versionupdates", force: true do |t|
    t.integer "currentversion", null: false
    t.integer "needupdate",     null: false
  end

end
