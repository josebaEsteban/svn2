# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 0) do

  create_table "answers", :force => true do |t|
    t.column "quest_id",     :integer,                               :null => false
    t.column "user_id",      :integer,                :default => 0, :null => false
    t.column "competition",  :text
    t.column "answ1",        :integer,  :limit => 3
    t.column "answ2",        :integer,  :limit => 3
    t.column "answ3",        :integer,  :limit => 3
    t.column "answ4",        :integer,  :limit => 3
    t.column "answ5",        :integer,  :limit => 3
    t.column "answ6",        :integer,  :limit => 3
    t.column "answ7",        :integer,  :limit => 3
    t.column "answ8",        :integer,  :limit => 3
    t.column "answ9",        :integer,  :limit => 3
    t.column "answ10",       :integer,  :limit => 3
    t.column "answ11",       :integer,  :limit => 3
    t.column "answ12",       :integer,  :limit => 3
    t.column "answ13",       :integer,  :limit => 3
    t.column "answ14",       :integer,  :limit => 3
    t.column "answ15",       :integer,  :limit => 3
    t.column "answ16",       :integer,  :limit => 3
    t.column "answ17",       :integer,  :limit => 3
    t.column "answ18",       :integer,  :limit => 3
    t.column "answ19",       :integer,  :limit => 3
    t.column "answ20",       :integer,  :limit => 3
    t.column "answ21",       :integer,  :limit => 3
    t.column "answ22",       :integer,  :limit => 3
    t.column "answ23",       :integer,  :limit => 3
    t.column "answ24",       :integer,  :limit => 3
    t.column "answ25",       :integer,  :limit => 3
    t.column "answ26",       :integer,  :limit => 3
    t.column "answ27",       :integer,  :limit => 3
    t.column "answ28",       :integer,  :limit => 3
    t.column "answ29",       :integer,  :limit => 3
    t.column "answ30",       :integer,  :limit => 3
    t.column "answ31",       :integer,  :limit => 3
    t.column "answ32",       :integer,  :limit => 3
    t.column "answ33",       :integer,  :limit => 3
    t.column "answ34",       :integer,  :limit => 3
    t.column "answ35",       :integer,  :limit => 3
    t.column "answ36",       :integer,  :limit => 3
    t.column "answ37",       :integer,  :limit => 3
    t.column "answ38",       :integer,  :limit => 3
    t.column "answ39",       :integer,  :limit => 3
    t.column "answ40",       :integer,  :limit => 3
    t.column "answ41",       :integer,  :limit => 3
    t.column "answ42",       :integer,  :limit => 3
    t.column "answ43",       :integer,  :limit => 3
    t.column "answ44",       :integer,  :limit => 3
    t.column "answ45",       :integer,  :limit => 3
    t.column "answ46",       :integer,  :limit => 3
    t.column "answ47",       :integer,  :limit => 3
    t.column "answ48",       :integer,  :limit => 3
    t.column "answ49",       :integer,  :limit => 3
    t.column "answ50",       :integer,  :limit => 3
    t.column "answ51",       :integer,  :limit => 3
    t.column "answ52",       :integer,  :limit => 3
    t.column "answ53",       :integer,  :limit => 3
    t.column "answ54",       :integer,  :limit => 3
    t.column "answ55",       :integer,  :limit => 3
    t.column "answ56",       :integer,  :limit => 3
    t.column "answ57",       :integer,  :limit => 3
    t.column "answ58",       :integer,  :limit => 3
    t.column "answ59",       :integer,  :limit => 3
    t.column "answ60",       :integer,  :limit => 3
    t.column "answ61",       :integer,  :limit => 3
    t.column "answ62",       :integer,  :limit => 3
    t.column "answ63",       :integer,  :limit => 3
    t.column "answ64",       :integer,  :limit => 3
    t.column "answ65",       :integer,  :limit => 3
    t.column "answ66",       :integer,  :limit => 3
    t.column "answ67",       :integer,  :limit => 3
    t.column "answ68",       :integer,  :limit => 3
    t.column "answ69",       :integer,  :limit => 3
    t.column "answ70",       :integer,  :limit => 3
    t.column "answ71",       :integer,  :limit => 3
    t.column "answ72",       :integer,  :limit => 3
    t.column "answ73",       :integer,  :limit => 3
    t.column "answ74",       :integer,  :limit => 3
    t.column "answ75",       :integer,  :limit => 3
    t.column "answ76",       :integer,  :limit => 3
    t.column "answ77",       :integer,  :limit => 3
    t.column "browse",       :integer,  :limit => 3,  :default => 0, :null => false
    t.column "note1",        :text
    t.column "note2",        :text
    t.column "checked",      :integer,  :limit => 3,  :default => 0, :null => false
    t.column "created_on",   :datetime
    t.column "note3",        :text
    t.column "note4",        :text
    t.column "note5",        :text
    t.column "ip",           :string,   :limit => 15
    t.column "time_to_fill", :time,                                  :null => false
  end

  add_index "answers", ["user_id"], :name => "user_id"

  create_table "attachments", :force => true do |t|
    t.column "container_id",   :integer,                :default => 0,  :null => false
    t.column "container_type", :string,   :limit => 30, :default => "", :null => false
    t.column "filename",       :string,                 :default => "", :null => false
    t.column "disk_filename",  :string,                 :default => "", :null => false
    t.column "filesize",       :integer,                :default => 0,  :null => false
    t.column "content_type",   :string,   :limit => 60, :default => ""
    t.column "digest",         :string,   :limit => 40, :default => "", :null => false
    t.column "downloads",      :integer,                :default => 0,  :null => false
    t.column "author_id",      :integer,                :default => 0,  :null => false
    t.column "created_on",     :datetime
  end

  create_table "journals", :force => true do |t|
    t.column "event",        :string,   :limit => 30,  :default => "", :null => false
    t.column "created_on",   :datetime
    t.column "ip",           :string,   :limit => 15
    t.column "user_id",      :integer,                 :default => 0,  :null => false
    t.column "owner_id",     :integer,                                 :null => false
    t.column "country",      :string,   :limit => 5
    t.column "region",       :string,   :limit => 30
    t.column "city",         :string,   :limit => 30
    t.column "latitude",     :string,   :limit => 20
    t.column "longitude",    :string,   :limit => 20
    t.column "organization", :string,   :limit => 100
  end

  add_index "journals", ["user_id"], :name => "user"

  create_table "members", :force => true do |t|
    t.column "user_id",    :integer,  :default => 0, :null => false
    t.column "project_id", :integer,  :default => 0, :null => false
    t.column "role_id",    :integer,  :default => 0, :null => false
    t.column "created_on", :datetime
  end

  create_table "messages", :force => true do |t|
    t.column "board_id",      :integer,                  :null => false
    t.column "parent_id",     :integer
    t.column "subject",       :string,   :default => "", :null => false
    t.column "content",       :text
    t.column "author_id",     :integer
    t.column "replies_count", :integer,  :default => 0,  :null => false
    t.column "last_reply_id", :integer
    t.column "created_on",    :datetime,                 :null => false
    t.column "updated_on",    :datetime,                 :null => false
  end

  add_index "messages", ["board_id"], :name => "messages_board_id"
  add_index "messages", ["parent_id"], :name => "messages_parent_id"

  create_table "permissions", :force => true do |t|
    t.column "controller",   :string,  :limit => 30, :default => "",    :null => false
    t.column "action",       :string,  :limit => 30, :default => "",    :null => false
    t.column "description",  :string,  :limit => 60, :default => "",    :null => false
    t.column "is_public",    :boolean,               :default => false, :null => false
    t.column "sort",         :integer,               :default => 0,     :null => false
    t.column "mail_option",  :boolean,               :default => false, :null => false
    t.column "mail_enabled", :boolean,               :default => false, :null => false
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.column "permission_id", :integer, :default => 0, :null => false
    t.column "role_id",       :integer, :default => 0, :null => false
  end

  add_index "permissions_roles", ["role_id"], :name => "permissions_roles_role_id"

  create_table "projects", :force => true do |t|
    t.column "name",           :string,   :limit => 30, :default => "",   :null => false
    t.column "description",    :string,                 :default => "",   :null => false
    t.column "homepage",       :string,   :limit => 60, :default => ""
    t.column "is_public",      :boolean,                :default => true, :null => false
    t.column "parent_id",      :integer
    t.column "projects_count", :integer,                :default => 0
    t.column "created_on",     :datetime
    t.column "updated_on",     :datetime
    t.column "identifier",     :string,   :limit => 20
    t.column "status",         :integer,                :default => 1,    :null => false
  end

  create_table "roles", :force => true do |t|
    t.column "name",     :string,  :limit => 30, :default => "", :null => false
    t.column "position", :integer,               :default => 1,  :null => false
  end

  create_table "settings", :force => true do |t|
    t.column "name",  :string, :limit => 30, :default => "", :null => false
    t.column "value", :text
  end

  create_table "tokens", :force => true do |t|
    t.column "user_id",    :integer,                :default => 0,  :null => false
    t.column "action",     :string,   :limit => 30, :default => "", :null => false
    t.column "value",      :string,   :limit => 40, :default => "", :null => false
    t.column "created_on", :datetime,                               :null => false
  end

  create_table "user_preferences", :force => true do |t|
    t.column "user_id",   :integer, :default => 0,     :null => false
    t.column "others",    :text
    t.column "hide_mail", :boolean, :default => false
  end

  create_table "users", :force => true do |t|
    t.column "login",             :string,    :limit => 30, :default => "",              :null => false
    t.column "hashed_password",   :string,    :limit => 40, :default => "",              :null => false
    t.column "firstname",         :string,    :limit => 30, :default => "",              :null => false
    t.column "lastname",          :string,    :limit => 30, :default => "",              :null => false
    t.column "mail",              :string,    :limit => 60, :default => "",              :null => false
    t.column "mail_notification", :boolean,                 :default => true,            :null => false
    t.column "admin",             :boolean,                 :default => false,           :null => false
    t.column "status",            :integer,                 :default => 1,               :null => false
    t.column "last_login_on",     :datetime
    t.column "language",          :string,    :limit => 5,  :default => ""
    t.column "auth_source_id",    :integer
    t.column "created_on",        :datetime
    t.column "ip",                :string,    :limit => 15
    t.column "role",              :integer,                 :default => 1,               :null => false
    t.column "time_zone",         :string,    :limit => 40, :default => "Europe/Madrid"
    t.column "ip_last",           :string,    :limit => 15
    t.column "start",             :timestamp,                                            :null => false
    t.column "managed_by",        :integer
  end

  add_index "users", ["managed_by"], :name => "managed_by"

end
