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

ActiveRecord::Schema[7.1].define(version: 2024_08_22_100305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "dosages", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medications", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_takings", force: :cascade do |t|
    t.bigint "planifications_id", null: false
    t.bigint "taking_periods_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planifications_id"], name: "index_plan_takings_on_planifications_id"
    t.index ["taking_periods_id"], name: "index_plan_takings_on_taking_periods_id"
  end

  create_table "planifications", force: :cascade do |t|
    t.integer "quantity"
    t.date "start_date"
    t.date "end_date"
    t.bigint "medication_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "dosage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "frequency_days"
    t.index ["dosage_id"], name: "index_planifications_on_dosage_id"
    t.index ["medication_id"], name: "index_planifications_on_medication_id"
    t.index ["patient_id"], name: "index_planifications_on_patient_id"
  end

  create_table "takes", force: :cascade do |t|
    t.date "datetime"
    t.bigint "planifications_id", null: false
    t.date "taken_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planifications_id"], name: "index_takes_on_planifications_id"
  end

  create_table "taking_periods", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutor_patients", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_tutor_patients_on_patient_id"
    t.index ["tutor_id"], name: "index_tutor_patients_on_tutor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "plan_takings", "planifications", column: "planifications_id"
  add_foreign_key "plan_takings", "taking_periods", column: "taking_periods_id"
  add_foreign_key "planifications", "dosages"
  add_foreign_key "planifications", "medications"
  add_foreign_key "planifications", "users", column: "patient_id"
  add_foreign_key "takes", "planifications", column: "planifications_id"
  add_foreign_key "tutor_patients", "users", column: "patient_id"
  add_foreign_key "tutor_patients", "users", column: "tutor_id"
end
