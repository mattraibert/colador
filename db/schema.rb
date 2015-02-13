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

ActiveRecord::Schema.define(version: 20150212235826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "start_year",  null: false
    t.integer  "end_year"
    t.integer  "category_id", null: false
    t.integer  "location_id"
    t.string   "source"
    t.string   "size",        null: false
    t.boolean  "published",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "events", ["category_id"], name: "index_events_on_category_id", using: :btree
  add_index "events", ["location_id"], name: "index_events_on_location_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "abbr"
    t.integer  "top"
    t.integer  "left"
    t.string   "name"
    t.point    "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uw_la_entries", primary_key: "uw_id", force: :cascade do |t|
    t.text    "uw_title",              null: false
    t.integer "uw_start",    limit: 8, null: false
    t.integer "uw_end",      limit: 8, null: false
    t.text    "uw_loc",                null: false
    t.text    "uw_category",           null: false
    t.text    "uw_source",             null: false
    t.text    "uw_content",            null: false
    t.text    "uw_size",               null: false
    t.boolean "uw_draft",              null: false
  end

  create_table "uw_la_misc", primary_key: "uw_key", force: :cascade do |t|
    t.text "uw_data", null: false
  end

  create_table "uw_userpass_s", primary_key: "uw_loggedin", force: :cascade do |t|
    t.text "uw_user",    null: false
    t.text "uw_session", null: false
  end

  create_table "uw_userpass_u", primary_key: "uw_user", force: :cascade do |t|
    t.text "uw_salt",     null: false
    t.text "uw_password", null: false
  end

  add_foreign_key "events", "categories"
end
