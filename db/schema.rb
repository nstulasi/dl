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

ActiveRecord::Schema.define(:version => 20120605195200) do

  create_table "articles", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "delegation_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "defaultphases", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "content"
  end

  create_table "delegations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "role"
    t.string   "responsibility"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.date     "start_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "end_at"
    t.integer  "project_id"
  end

  create_table "mercury_images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta", :force => true do |t|
    t.string   "stream_xml"
    t.string   "structure_xml"
    t.string   "space_xml"
    t.string   "scenario_xml"
    t.string   "society_xml"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_id"
  end

  create_table "phases", :force => true do |t|
    t.string   "name"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "start"
    t.datetime "end"
    t.string   "site"
  end

# Could not dump table "policies" because of following StandardError
#   Unknown type '' for column 'checked'

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "time"
    t.string   "money"
    t.string   "funding_agency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "scenarios", :force => true do |t|
    t.string   "xmlcontent"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "societies", :force => true do |t|
    t.string   "xmlcontent"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spaces", :force => true do |t|
    t.string   "xmlcontent"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "streams", :force => true do |t|
    t.text     "xmlcontent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "structures", :force => true do |t|
    t.string   "xmlcontent"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.string   "status"
    t.string   "priority"
    t.date     "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.integer  "project_id"
    t.string   "site"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "role"
    t.string   "responsibilities"
    t.string   "webpage"
    t.string   "number"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
