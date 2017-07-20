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

ActiveRecord::Schema.define(version: 20170720133752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "people", force: :cascade do |t|
    t.integer  "code"
    t.string   "name",        limit: 60,             null: false
    t.integer  "person_type",            default: 1
    t.string   "phone",       limit: 25
    t.string   "address"
    t.string   "note"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "code"
    t.string   "name",           limit: 60,                                          null: false
    t.string   "barcode",        limit: 13,                                          null: false
    t.decimal  "price_in",                  precision: 11, scale: 2
    t.decimal  "price_out",                 precision: 11, scale: 2
    t.integer  "section_id"
    t.integer  "unit_id",                                            default: 1
    t.integer  "refill",                                             default: 1
    t.integer  "unit_refill_id",                                     default: 2
    t.boolean  "service",                                            default: false
    t.decimal  "discount_value",            precision: 11, scale: 2, default: "0.0"
    t.decimal  "tax",                       precision: 11, scale: 2, default: "0.0"
    t.string   "note"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.index ["section_id"], name: "index_products_on_section_id", using: :btree
    t.index ["unit_id"], name: "index_products_on_unit_id", using: :btree
    t.index ["unit_refill_id"], name: "index_products_on_unit_refill_id", using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.integer "code"
    t.string  "name", limit: 60, null: false
  end

  create_table "units", force: :cascade do |t|
    t.string "code"
    t.string "name", limit: 20, null: false
  end

  add_foreign_key "products", "sections"
  add_foreign_key "products", "units"
end
