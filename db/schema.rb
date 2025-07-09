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

ActiveRecord::Schema[7.1].define(version: 2025_07_08_153558) do
  create_table "love_tests", force: :cascade do |t|
    t.string "given_name_a"
    t.string "surname_a"
    t.string "given_name_b"
    t.string "surname_b"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "name_searches", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "search_count", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name"], name: "index_name_searches_on_first_name_and_last_name", unique: true
  end

  create_table "quotes", force: :cascade do |t|
    t.text "quote"
    t.string "author"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_readings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "person1_first"
    t.string "person1_last"
    t.string "person2_first"
    t.string "person2_last"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_readings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "last_login_date"
    t.integer "login_streak"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "user_readings", "users"
end
