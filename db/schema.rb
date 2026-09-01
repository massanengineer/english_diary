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

ActiveRecord::Schema[8.1].define(version: 2026_09_01_033103) do
  create_table "diary_entries", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.text "english_content"
    t.date "entry_date"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_diary_entries_on_user_id"
  end

  create_table "diary_entry_vocabularies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "diary_entry_id", null: false
    t.datetime "updated_at", null: false
    t.integer "vocabulary_id", null: false
    t.index ["diary_entry_id"], name: "index_diary_entry_vocabularies_on_diary_entry_id"
    t.index ["vocabulary_id"], name: "index_diary_entry_vocabularies_on_vocabulary_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabularies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "meaning_ja"
    t.string "phrase"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "diary_entries", "users"
  add_foreign_key "diary_entry_vocabularies", "diary_entries"
  add_foreign_key "diary_entry_vocabularies", "vocabularies"
end
