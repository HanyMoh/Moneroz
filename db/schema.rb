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

ActiveRecord::Schema.define(version: 20171024035322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doc_items", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "product_id"
    t.integer  "quantity",                                default: 1
    t.decimal  "price",          precision: 11, scale: 2, default: "0.0"
    t.integer  "effect",                                  default: 0
    t.decimal  "discount_value", precision: 8,  scale: 2, default: "0.0"
    t.boolean  "returned",                                default: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["document_id"], name: "index_doc_items_on_document_id", using: :btree
    t.index ["product_id"], name: "index_doc_items_on_product_id", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.date     "doc_date"
    t.integer  "code"
    t.integer  "store_id"
    t.integer  "storage_id"
    t.integer  "person_id"
    t.integer  "user_id"
    t.decimal  "payment",        precision: 11, scale: 2, default: "0.0"
    t.integer  "doc_type",                                default: 0
    t.integer  "effect",                                  default: 0
    t.decimal  "discount_value", precision: 8,  scale: 2, default: "0.0"
    t.decimal  "discount_ratio", precision: 8,  scale: 2, default: "0.0"
    t.decimal  "tax",            precision: 8,  scale: 2, default: "0.0"
    t.boolean  "hold",                                    default: false
    t.string   "note"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.decimal  "total_price"
    t.index ["person_id"], name: "index_documents_on_person_id", using: :btree
    t.index ["storage_id"], name: "index_documents_on_storage_id", using: :btree
    t.index ["store_id"], name: "index_documents_on_store_id", using: :btree
    t.index ["user_id"], name: "index_documents_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "code"
    t.date     "pay_date"
    t.integer  "pay_type"
    t.integer  "effect"
    t.integer  "storage_id"
    t.integer  "person_id"
    t.decimal  "money",       precision: 8, scale: 2
    t.string   "description"
    t.integer  "user_id"
    t.string   "note"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["person_id"], name: "index_payments_on_person_id", using: :btree
    t.index ["storage_id"], name: "index_payments_on_storage_id", using: :btree
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

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
    t.integer  "quantity"
    t.index ["name"], name: "index_products_on_name", using: :btree
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

  create_table "users", force: :cascade do |t|
    t.string   "user_name",              default: "",      null: false
    t.boolean  "active",                 default: false
    t.string   "role",                   default: "guest", null: false
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree
  end

end
