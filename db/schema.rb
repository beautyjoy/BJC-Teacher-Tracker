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

ActiveRecord::Schema.define(version: 20191211072821) do

  create_table "admins", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_google_token"
    t.string   "encrypted_google_token_iv"
    t.string   "encrypted_google_refresh_token"
    t.string   "encrypted_google_refresh_token_iv"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email", "first_name"], name: "index_admins_on_emails_and_first_name"

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "website"
    t.float    "lat"
    t.float    "lng"
    t.integer  "teachers_count", default: 0
    t.datetime "created_at",     default: '2019-12-11 07:35:22'
    t.datetime "updated_at",     default: '2019-12-11 07:35:22'
  end

  add_index "schools", ["name", "city", "website"], name: "index_schools_on_name_city_and_website"

  create_table "teachers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "course"
    t.string   "snap"
    t.string   "other"
    t.integer  "school_id"
    t.integer  "school_name"
    t.boolean  "validated"
    t.boolean  "boolean"
    t.datetime "created_at",  default: '2019-12-11 07:35:22'
    t.datetime "updated_at",  default: '2019-12-11 07:35:22'
  end

  add_index "teachers", ["email", "first_name"], name: "index_teachers_on_email_and_first_name"

end
