# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "answers", :force => true do |t|
    t.integer  "quest_id",                                      :null => false
    t.integer  "user_id",                    :default => 0,     :null => false
    t.text     "competition"
    t.integer  "answ1",        :limit => 3
    t.integer  "answ2",        :limit => 3
    t.integer  "answ3",        :limit => 3
    t.integer  "answ4",        :limit => 3
    t.integer  "answ5",        :limit => 3
    t.integer  "answ6",        :limit => 3
    t.integer  "answ7",        :limit => 3
    t.integer  "answ8",        :limit => 3
    t.integer  "answ9",        :limit => 3
    t.integer  "answ10",       :limit => 3
    t.integer  "answ11",       :limit => 3
    t.integer  "answ12",       :limit => 3
    t.integer  "answ13",       :limit => 3
    t.integer  "answ14",       :limit => 3
    t.integer  "answ15",       :limit => 3
    t.integer  "answ16",       :limit => 3
    t.integer  "answ17",       :limit => 3
    t.integer  "answ18",       :limit => 3
    t.integer  "answ19",       :limit => 3
    t.integer  "answ20",       :limit => 3
    t.integer  "answ21",       :limit => 3
    t.integer  "answ22",       :limit => 3
    t.integer  "answ23",       :limit => 3
    t.integer  "answ24",       :limit => 3
    t.integer  "answ25",       :limit => 3
    t.integer  "answ26",       :limit => 3
    t.integer  "answ27",       :limit => 3
    t.integer  "answ28",       :limit => 3
    t.integer  "answ29",       :limit => 3
    t.integer  "answ30",       :limit => 3
    t.integer  "answ31",       :limit => 3
    t.integer  "answ32",       :limit => 3
    t.integer  "answ33",       :limit => 3
    t.integer  "answ34",       :limit => 3
    t.integer  "answ35",       :limit => 3
    t.integer  "answ36",       :limit => 3
    t.integer  "answ37",       :limit => 3
    t.integer  "answ38",       :limit => 3
    t.integer  "answ39",       :limit => 3
    t.integer  "answ40",       :limit => 3
    t.integer  "answ41",       :limit => 3
    t.integer  "answ42",       :limit => 3
    t.integer  "answ43",       :limit => 3
    t.integer  "answ44",       :limit => 3
    t.integer  "answ45",       :limit => 3
    t.integer  "answ46",       :limit => 3
    t.integer  "answ47",       :limit => 3
    t.integer  "answ48",       :limit => 3
    t.integer  "answ49",       :limit => 3
    t.integer  "answ50",       :limit => 3
    t.integer  "answ51",       :limit => 3
    t.integer  "answ52",       :limit => 3
    t.integer  "answ53",       :limit => 3
    t.integer  "answ54",       :limit => 3
    t.integer  "answ55",       :limit => 3
    t.integer  "answ56",       :limit => 3
    t.integer  "answ57",       :limit => 3
    t.integer  "answ58",       :limit => 3
    t.integer  "answ59",       :limit => 3
    t.integer  "answ60",       :limit => 3
    t.integer  "answ61",       :limit => 3
    t.integer  "answ62",       :limit => 3
    t.integer  "answ63",       :limit => 3
    t.integer  "answ64",       :limit => 3
    t.integer  "answ65",       :limit => 3
    t.integer  "answ66",       :limit => 3
    t.integer  "answ67",       :limit => 3
    t.integer  "answ68",       :limit => 3
    t.integer  "answ69",       :limit => 3
    t.integer  "answ70",       :limit => 3
    t.integer  "answ71",       :limit => 3
    t.integer  "answ72",       :limit => 3
    t.integer  "answ73",       :limit => 3
    t.integer  "answ74",       :limit => 3
    t.integer  "answ75",       :limit => 3
    t.integer  "answ76",       :limit => 3
    t.integer  "answ77",       :limit => 3
    t.boolean  "browse",                     :default => false, :null => false
    t.text     "note1"
    t.text     "note2"
    t.integer  "checked",      :limit => 3,  :default => 0,     :null => false
    t.datetime "created_on"
    t.text     "note3"
    t.text     "note4"
    t.text     "note5"
    t.string   "ip",           :limit => 15
    t.time     "time_to_fill",                                  :null => false
    t.integer  "filled_by"
  end

  add_index "answers", ["user_id"], :name => "user_id"

  create_table "attachments", :force => true do |t|
    t.integer  "container_id",                 :default => 0,  :null => false
    t.string   "container_type", :limit => 30, :default => "", :null => false
    t.string   "filename",                     :default => "", :null => false
    t.string   "disk_filename",                :default => "", :null => false
    t.integer  "filesize",                     :default => 0,  :null => false
    t.string   "content_type",   :limit => 60
    t.string   "digest",         :limit => 40, :default => "", :null => false
    t.integer  "downloads",                    :default => 0,  :null => false
    t.integer  "author_id",                    :default => 0,  :null => false
    t.datetime "created_on"
  end

  create_table "books", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order",      :limit => 2
    t.boolean  "browse",                  :default => false, :null => false
    t.datetime "updated_on"
  end

  add_index "books", ["user_id"], :name => "user_id"

  create_table "journals", :force => true do |t|
    t.string   "event",        :limit => 60,  :default => "", :null => false
    t.datetime "created_on"
    t.string   "ip",           :limit => 15
    t.integer  "user_id",                     :default => 0,  :null => false
    t.integer  "owner_id",                                    :null => false
    t.string   "country",      :limit => 5
    t.string   "region",       :limit => 30
    t.string   "city",         :limit => 30
    t.string   "latitude",     :limit => 20
    t.string   "longitude",    :limit => 20
    t.string   "organization", :limit => 100
  end

  add_index "journals", ["user_id"], :name => "user"

  create_table "members", :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.integer  "project_id", :default => 0, :null => false
    t.integer  "role_id",    :default => 0, :null => false
    t.datetime "created_on"
  end

  create_table "messages", :force => true do |t|
    t.integer  "board_id",   :null => false
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_on", :null => false
    t.integer  "answer_id"
  end

  add_index "messages", ["board_id"], :name => "messages_board_id"
  add_index "messages", ["created_on"], :name => "messages_created_on"
  add_index "messages", ["answer_id"], :name => "messages_answer_id"

  create_table "pendings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "quest_id",   :limit => 2
    t.datetime "created_on"
  end

  add_index "pendings", ["user_id"], :name => "user_id"
  add_index "pendings", ["quest_id"], :name => "quest_id"

  create_table "permissions", :force => true do |t|
    t.string  "controller",   :limit => 30, :default => "",    :null => false
    t.string  "action",       :limit => 30, :default => "",    :null => false
    t.string  "description",  :limit => 60, :default => "",    :null => false
    t.boolean "is_public",                  :default => false, :null => false
    t.integer "sort",                       :default => 0,     :null => false
    t.boolean "mail_option",                :default => false, :null => false
    t.boolean "mail_enabled",               :default => false, :null => false
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id", :default => 0, :null => false
    t.integer "role_id",       :default => 0, :null => false
  end

  add_index "permissions_roles", ["role_id"], :name => "permissions_roles_role_id"

  create_table "projects", :force => true do |t|
    t.string   "name",           :limit => 30, :default => "",   :null => false
    t.string   "description",                  :default => "",   :null => false
    t.string   "homepage",       :limit => 60, :default => ""
    t.boolean  "is_public",                    :default => true, :null => false
    t.integer  "parent_id"
    t.integer  "projects_count",               :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "identifier",     :limit => 20
    t.integer  "status",                       :default => 1,    :null => false
  end

  create_table "quests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order",      :limit => 2
    t.boolean  "browse",                  :default => false, :null => false
    t.datetime "updated_on"
  end

  add_index "quests", ["user_id"], :name => "user_id"
  add_index "quests", ["order"], :name => "order"

  create_table "roles", :force => true do |t|
    t.string  "name",     :limit => 30, :default => "", :null => false
    t.integer "position",               :default => 1,  :null => false
  end

  create_table "settings", :force => true do |t|
    t.string "name",  :limit => 30, :default => "", :null => false
    t.text   "value"
  end

  create_table "tokens", :force => true do |t|
    t.integer  "user_id",                  :default => 0,  :null => false
    t.string   "action",     :limit => 30, :default => "", :null => false
    t.string   "value",      :limit => 40, :default => "", :null => false
    t.datetime "created_on",                               :null => false
  end

  create_table "user_preferences", :force => true do |t|
    t.integer "user_id",   :default => 0,     :null => false
    t.text    "others"
    t.boolean "hide_mail", :default => false
  end

  create_table "users", :force => true do |t|
    t.string    "login",             :limit => 30, :default => "",              :null => false
    t.string    "hashed_password",   :limit => 40, :default => "",              :null => false
    t.string    "firstname",         :limit => 30, :default => "",              :null => false
    t.string    "lastname",          :limit => 30, :default => "",              :null => false
    t.string    "mail",              :limit => 60, :default => "",              :null => false
    t.boolean   "mail_notification",               :default => true,            :null => false
    t.boolean   "admin",                           :default => false,           :null => false
    t.integer   "status",                          :default => 1,               :null => false
    t.datetime  "last_login_on"
    t.string    "language",          :limit => 5,  :default => ""
    t.integer   "auth_source_id"
    t.datetime  "created_on"
    t.string    "ip",                :limit => 15
    t.integer   "role",                            :default => 1,               :null => false
    t.string    "time_zone",         :limit => 40, :default => "Europe/Madrid", :null => false
    t.string    "ip_last",           :limit => 15, :default => "",              :null => false
    t.timestamp "start",                                                        :null => false
    t.integer   "managed_by"
    t.integer   "filled_for"
    t.datetime  "updated_on"
  end

  add_index "users", ["managed_by"], :name => "managed_by"

end
