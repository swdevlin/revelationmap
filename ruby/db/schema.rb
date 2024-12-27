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

ActiveRecord::Schema[8.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "knex_migrations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "batch"
    t.timestamptz "migration_time"
  end

  create_table "knex_migrations_lock", primary_key: "index", id: :serial, force: :cascade do |t|
    t.integer "is_locked"
  end

  create_table "sector", id: :serial, force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.string "name", limit: 255, null: false
    t.string "abbreviation", limit: 255, null: false

    t.unique_constraint ["x", "y"], name: "sector_x_y_unique"
  end

  create_table "solar_system", id: :serial, force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.string "name", limit: 255
    t.integer "scan_points", default: 0, null: false
    t.integer "survey_index", default: 0, null: false
    t.integer "sector_id", null: false
    t.integer "gas_giant_count", default: 0, null: false
    t.integer "planetoid_belt_count", default: 0, null: false
    t.integer "terrestrial_planet_count", default: 0, null: false
    t.text "bases"
    t.text "remarks"
    t.boolean "native_sophont", default: false, null: false
    t.boolean "extinct_sophont", default: false, null: false
    t.integer "star_count", default: 1, null: false
    t.jsonb "main_world"
    t.jsonb "primary_star", null: false
    t.jsonb "stars", null: false
    t.text "allegiance"

    t.unique_constraint ["sector_id", "x", "y"], name: "solar_system_sector_id_x_y_unique"
  end

  add_foreign_key "solar_system", "sector", name: "solar_system_sector_id_foreign", on_delete: :cascade
end
