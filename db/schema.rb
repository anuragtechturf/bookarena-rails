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

ActiveRecord::Schema[8.0].define(version: 2025_07_20_144532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "gender_enum", ["male", "female", "other", "undisclosed"]
  create_enum "user_status_enum", ["active", "inactive", "suspended"]

  create_table "phone_otps", force: :cascade do |t|
    t.string "phone_number"
    t.string "otp_code"
    t.datetime "expires_at"
    t.boolean "verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.text "password_digest"
    t.string "otp_secret"
    t.boolean "is_phone_verified", default: false
    t.string "referral_code"
    t.uuid "referred_by_user_id"
    t.enum "status", default: "active", null: false, enum_type: "user_status_enum"
    t.date "date_of_birth"
    t.enum "gender", enum_type: "gender_enum"
    t.text "profile_picture_url"
    t.datetime "last_login_at"
    t.datetime "deleted_at"
    t.uuid "created_by_user_id"
    t.uuid "updated_by_user_id"
    t.string "google_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_email_verified"
    t.boolean "phone_verified"
    t.index ["created_by_user_id"], name: "idx_users_created_by"
    t.index ["created_by_user_id"], name: "index_users_on_created_by_user_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_uid"], name: "index_users_on_google_uid", unique: true, where: "(google_uid IS NOT NULL)"
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
    t.index ["referred_by_user_id"], name: "idx_users_referred_by"
    t.index ["referred_by_user_id"], name: "index_users_on_referred_by_user_id"
    t.index ["status"], name: "index_users_on_status"
    t.index ["updated_by_user_id"], name: "idx_users_updated_by"
    t.index ["updated_by_user_id"], name: "index_users_on_updated_by_user_id"
    t.check_constraint "phone_number::text ~ '^\\+91[6-9][0-9]{9}$'::text", name: "phone_number_india_format"
  end

  add_foreign_key "users", "users", column: "created_by_user_id"
  add_foreign_key "users", "users", column: "referred_by_user_id"
  add_foreign_key "users", "users", column: "updated_by_user_id"
end
