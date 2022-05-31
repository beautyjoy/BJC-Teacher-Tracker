# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_28_021006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "dynamic_pages", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "permissions", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "creator_id", null: false
    t.bigint "last_editor", null: false
    t.bigint "teachers_id"
    t.index ["slug"], name: "index_dynamic_pages_on_slug", unique: true
    t.index ["teachers_id"], name: "index_dynamic_pages_on_teachers_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.text "body"
    t.string "path"
    t.string "locale"
    t.string "handler"
    t.boolean "partial"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "subject"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "website"
    t.float "lat"
    t.float "lng"
    t.integer "num_validated_teachers", default: 0
    t.integer "teachers_count", default: 0
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.integer "num_denied_teachers", default: 0
    t.integer "grade_level"
    t.integer "school_type"
    t.text "tags", default: [], array: true
    t.bigint "nces_id"
    t.index ["name", "city", "website"], name: "index_schools_on_name_city_and_website"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "snap"
    t.integer "school_id"
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.integer "status"
    t.string "more_info"
    t.boolean "admin", default: false
    t.string "encrypted_google_token"
    t.string "encrypted_google_token_iv"
    t.string "encrypted_google_refresh_token"
    t.string "encrypted_google_refresh_token_iv"
    t.string "personal_website"
    t.integer "education_level", default: -1
    t.string "application_status", default: "Pending"
    t.string "microsoft_token"
    t.string "microsoft_refresh_token"
    t.string "snap_token"
    t.string "snap_refresh_token"
    t.string "clever_token"
    t.string "clever_refresh_token"
    t.index ["email", "first_name"], name: "index_teachers_on_email_and_first_name"
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["school_id"], name: "index_teachers_on_school_id"
    t.index ["snap"], name: "index_teachers_on_snap", unique: true, where: "((snap)::text <> ''::text)"
    t.index ["status"], name: "index_teachers_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dynamic_pages", "teachers", column: "teachers_id"
end
