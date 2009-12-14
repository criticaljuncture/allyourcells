# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091214015129) do

  create_table "cell_sites", :force => true do |t|
    t.float    "lat"
    t.float    "lng"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "photo_md5_hash"
    t.integer  "email_uid"
    t.string   "licensee"
    t.string   "callsign"
    t.string   "location_number"
    t.string   "address"
    t.string   "city"
    t.string   "county"
    t.string   "state"
    t.string   "nepa"
    t.string   "qzone"
    t.string   "tower_reg"
    t.float    "supporting_structure_height"
    t.float    "structure_height"
    t.string   "structure_type"
    t.string   "license_id"
  end

  add_index "cell_sites", ["lat"], :name => "index_cell_sites_on_lat"
  add_index "cell_sites", ["license_id"], :name => "index_cell_sites_on_license_id"
  add_index "cell_sites", ["lng"], :name => "index_cell_sites_on_lng"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email",                                  :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",              :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
