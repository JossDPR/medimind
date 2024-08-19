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

ActiveRecord::Schema[7.1].define(version: 2024_08_19_130842) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alarms", force: :cascade do |t|
    t.datetime "datetime"
    t.bigint "planification_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planification_id"], name: "index_alarms_on_planification_id"
  end

  create_table "dosages", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "frequencies", force: :cascade do |t|
    t.integer "amount"
    t.bigint "periodicity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["periodicity_id"], name: "index_frequencies_on_periodicity_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periodicities", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "planifications", force: :cascade do |t|
    t.integer "quantity"
    t.date "start_date"
    t.date "end_date"
    t.string "photo_key"
    t.bigint "medication_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "dosage_id", null: false
    t.bigint "frequency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dosage_id"], name: "index_planifications_on_dosage_id"
    t.index ["frequency_id"], name: "index_planifications_on_frequency_id"
    t.index ["medication_id"], name: "index_planifications_on_medication_id"
    t.index ["patient_id"], name: "index_planifications_on_patient_id"
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

  add_foreign_key "alarms", "planifications"
  add_foreign_key "frequencies", "periodicities"
  add_foreign_key "planifications", "dosages"
  add_foreign_key "planifications", "frequencies"
  add_foreign_key "planifications", "medications"
  add_foreign_key "planifications", "users", column: "patient_id"
  add_foreign_key "tutor_patients", "users", column: "patient_id"
  add_foreign_key "tutor_patients", "users", column: "tutor_id"
end
