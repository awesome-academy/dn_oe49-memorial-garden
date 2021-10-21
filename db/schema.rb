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

ActiveRecord::Schema.define(version: 2021_10_21_071540) do

  create_table "access_privacies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "memorial_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["memorial_id"], name: "index_access_privacies_on_memorial_id"
    t.index ["user_id"], name: "index_access_privacies_on_user_id"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "contribution_id", null: false
    t.string "title"
    t.integer "attachment_type", null: false
    t.string "photo"
    t.string "audio"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contribution_id"], name: "index_attachments_on_contribution_id"
  end

  create_table "contributions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "memorial_id", null: false
    t.bigint "user_id", null: false
    t.integer "contribution_type", null: false
    t.string "relationship", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["memorial_id"], name: "index_contributions_on_memorial_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "flowers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "contribution_id", null: false
    t.integer "type", default: 0, null: false
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contribution_id"], name: "index_flowers_on_contribution_id"
  end

  create_table "memorials", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender"
    t.string "cause_of_death"
    t.bigint "user_id", null: false
    t.string "background_song"
    t.string "avatar"
    t.string "relationship", null: false
    t.integer "privacy_type", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_memorials_on_user_id"
  end

  create_table "placetimes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "memorial_id", null: false
    t.string "location"
    t.datetime "date"
    t.boolean "is_born"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["memorial_id"], name: "index_placetimes_on_memorial_id"
  end

  create_table "stories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "contribution_id", null: false
    t.string "image"
    t.string "content", null: false
    t.bigint "rep_story_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contribution_id"], name: "index_stories_on_contribution_id"
    t.index ["rep_story_id"], name: "index_stories_on_rep_story_id"
  end

  create_table "tributes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "contribution_id", null: false
    t.string "eulogy", null: false
    t.bigint "rep_tribute_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contribution_id"], name: "index_tributes_on_contribution_id"
    t.index ["rep_tribute_id"], name: "index_tributes_on_rep_tribute_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender"
    t.string "email", null: false
    t.string "avatar"
    t.integer "admin", default: 0, null: false
    t.string "password_digest", null: false
    t.string "activate_digest"
    t.string "reset_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "access_privacies", "memorials"
  add_foreign_key "access_privacies", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attachments", "contributions"
  add_foreign_key "contributions", "memorials"
  add_foreign_key "contributions", "users"
  add_foreign_key "flowers", "contributions"
  add_foreign_key "memorials", "users"
  add_foreign_key "placetimes", "memorials"
  add_foreign_key "stories", "contributions"
  add_foreign_key "stories", "stories", column: "rep_story_id"
  add_foreign_key "tributes", "contributions"
  add_foreign_key "tributes", "tributes", column: "rep_tribute_id"
end
