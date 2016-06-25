# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160625085638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_products", force: :cascade do |t|
    t.integer  "drug_application_id"
    t.string   "strength"
    t.string   "dosage"
    t.string   "market_status"
    t.string   "product_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.boolean  "patent_status"
  end

  create_table "drug_applications", force: :cascade do |t|
    t.integer  "drug_id"
    t.string   "application_number"
    t.string   "company"
    t.datetime "approval_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "brand_name"
    t.string   "generic_name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "discontinued", default: false
  end

  create_table "exclusivities", force: :cascade do |t|
    t.integer  "app_product_id"
    t.integer  "exclusivity_code_id"
    t.datetime "exclusivity_expiration"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "exclusivity_codes", force: :cascade do |t|
    t.string   "code"
    t.string   "definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patent_codes", force: :cascade do |t|
    t.string   "code"
    t.string   "definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patents", force: :cascade do |t|
    t.integer  "app_product_id"
    t.integer  "patent_code_id"
    t.string   "number"
    t.datetime "patent_expiration"
    t.string   "drug_substance_claim"
    t.string   "drug_product_claim"
    t.string   "delist_requested"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
