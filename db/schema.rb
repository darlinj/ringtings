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

ActiveRecord::Schema.define(:version => 20100127131958) do

  create_table "actions", :force => true do |t|
    t.integer  "callplan_id"
    t.string   "application_name"
    t.string   "application_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "callplans", :force => true do |t|
    t.string  "company_name"
    t.integer "user_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email_address"
    t.integer  "callplan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inbound_number_managers", :force => true do |t|
    t.string  "phone_number"
    t.integer "callplan_id"
    t.integer "ivr_menu_id"
  end

  create_table "ivr_menu_entries", :force => true do |t|
    t.string   "action"
    t.string   "digits"
    t.string   "system_param_part"
    t.integer  "ivr_menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prompt"
    t.string   "user_param_part"
  end

  create_table "ivr_menu_entry_prototypes", :force => true do |t|
    t.string "name"
    t.string "description"
    t.string "freeswitch_command_template"
    t.string "image"
    t.string "prompt"
  end

  create_table "ivr_menus", :force => true do |t|
    t.string   "name"
    t.string   "long_greeting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "action_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.boolean  "email_confirmed",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
