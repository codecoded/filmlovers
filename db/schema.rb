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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140503123148) do

  create_table "country_codes", :force => true do |t|
    t.string "name"
    t.string "iso_name"
    t.string "iso2"
    t.string "iso3"
    t.string "numcode"
  end

  create_table "facebook_events", :force => true do |t|
    t.integer  "user_id"
    t.string   "facebook_id"
    t.string   "event_type"
    t.string   "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "facebook_events", ["user_id"], :name => "index_facebook_events_on_user_id"

  create_table "film_entries", :force => true do |t|
    t.integer  "user_id"
    t.string   "film_id"
    t.integer  "facebook_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "watched",     :default => false, :null => false
    t.boolean  "loved",       :default => false, :null => false
    t.boolean  "owned",       :default => false, :null => false
  end

  add_index "film_entries", ["film_id", "user_id"], :name => "index_film_entries_film_and_user"
  add_index "film_entries", ["user_id", "film_id"], :name => "index_film_entries_on_user_id_and_film_id"
  add_index "film_entries", ["user_id"], :name => "index_film_actions_on_user_id"
  add_index "film_entries", ["watched", "loved", "owned"], :name => "index_film_entries_on_watched_and_loved_and_owned"

# Could not dump table "film_providers" because of following StandardError
#   Unknown type 'character varying(255)[]' for column 'storefront_ids'

  create_table "film_recommendations", :force => true do |t|
    t.integer  "user_id"
    t.string   "film_id"
    t.boolean  "auto"
    t.boolean  "sent"
    t.text     "comment"
    t.integer  "friend_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "film_recommendations", ["friend_id"], :name => "index_film_recommendations_on_friend_id"
  add_index "film_recommendations", ["user_id"], :name => "index_film_recommendations_on_user_id"

# Could not dump table "films" because of following StandardError
#   Unknown type 'character varying(255)[]' for column 'genres'

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "mobile_devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "mobile_devices", ["user_id"], :name => "index_mobile_devices_on_user_id"

  create_table "passports", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "passports", ["user_id"], :name => "index_passports_on_user_id"

  create_table "rapns_apps", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections", :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "type",                       :null => false
    t.string   "auth_key"
  end

  create_table "rapns_feedback", :force => true do |t|
    t.string   "device_token", :limit => 64, :null => false
    t.datetime "failed_at",                  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "app"
  end

  add_index "rapns_feedback", ["device_token"], :name => "index_rapns_feedback_on_device_token"

  create_table "rapns_notifications", :force => true do |t|
    t.integer  "badge"
    t.string   "device_token",      :limit => 64
    t.string   "sound",                           :default => "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                          :default => 86400
    t.boolean  "delivered",                       :default => false,     :null => false
    t.datetime "delivered_at"
    t.boolean  "failed",                          :default => false,     :null => false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.boolean  "alert_is_json",                   :default => false
    t.string   "type",                                                   :null => false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                :default => false,     :null => false
    t.text     "registration_ids"
    t.integer  "app_id",                                                 :null => false
    t.integer  "retries",                         :default => 0
  end

  add_index "rapns_notifications", ["app_id", "delivered", "failed", "deliver_after"], :name => "index_rapns_notifications_multi"

  create_table "user_profiles", :force => true do |t|
    t.string   "avatar"
    t.string   "cover_image"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "name"
    t.string   "gender"
    t.datetime "dob"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "avatar"
    t.string   "uuid"
  end

end
