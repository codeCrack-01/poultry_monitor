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

ActiveRecord::Schema[8.1].define(version: 2026_06_17_000007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.string "alert_type", null: false
    t.datetime "created_at", null: false
    t.bigint "farm_id", null: false
    t.string "message"
    t.datetime "resolved_at"
    t.bigint "sensor_id"
    t.integer "severity", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2
    t.bigint "zone_id"
    t.index ["farm_id", "status"], name: "index_alerts_on_farm_id_and_status"
    t.index ["farm_id"], name: "index_alerts_on_farm_id"
    t.index ["sensor_id"], name: "index_alerts_on_sensor_id"
    t.index ["severity"], name: "index_alerts_on_severity"
    t.index ["status"], name: "index_alerts_on_status"
    t.index ["zone_id"], name: "index_alerts_on_zone_id"
  end

  create_table "farms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_farms_on_status"
  end

  create_table "readings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "recorded_at", null: false
    t.bigint "sensor_id", null: false
    t.string "unit"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2
    t.index ["sensor_id", "recorded_at"], name: "index_readings_on_sensor_id_and_recorded_at"
    t.index ["sensor_id"], name: "index_readings_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label"
    t.integer "sensor_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "zone_id", null: false
    t.index ["sensor_type"], name: "index_sensors_on_sensor_type"
    t.index ["status"], name: "index_sensors_on_status"
    t.index ["zone_id"], name: "index_sensors_on_zone_id"
  end

  create_table "sheds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "farm_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_sheds_on_farm_id"
  end

  create_table "thresholds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "critical_max", precision: 10, scale: 2
    t.decimal "critical_min", precision: 10, scale: 2
    t.integer "sensor_type", null: false
    t.datetime "updated_at", null: false
    t.decimal "warning_max", precision: 10, scale: 2
    t.decimal "warning_min", precision: 10, scale: 2
    t.index ["sensor_type"], name: "index_thresholds_on_sensor_type", unique: true
  end

  create_table "zones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "shed_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["shed_id"], name: "index_zones_on_shed_id"
    t.index ["status"], name: "index_zones_on_status"
  end

  add_foreign_key "alerts", "farms"
  add_foreign_key "alerts", "sensors"
  add_foreign_key "alerts", "zones"
  add_foreign_key "readings", "sensors"
  add_foreign_key "sensors", "zones"
  add_foreign_key "sheds", "farms"
  add_foreign_key "zones", "sheds"
end
