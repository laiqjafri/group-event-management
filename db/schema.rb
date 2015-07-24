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

ActiveRecord::Schema.define(version: 20150724135115) do

  create_table "group_events", force: :cascade do |t|
    t.string   "name",         limit: 255,                   null: false
    t.text     "description",  limit: 65535
    t.string   "location",     limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "duration",     limit: 4
    t.boolean  "is_published",               default: false, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "deleted_at"
  end

  add_index "group_events", ["deleted_at"], name: "index_group_events_on_deleted_at", using: :btree

end
