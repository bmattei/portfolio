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

ActiveRecord::Schema.define(version: 2018_09_14_125015) do

  create_table "account_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "tax_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "account_number"
    t.string "brokerage"
    t.integer "account_type_id"
    t.integer "admin_user_id"
    t.decimal "cash", precision: 16, scale: 2
    t.decimal "holdings_value", precision: 16, scale: 2
    t.decimal "total_value", precision: 16, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.integer "resource_id"
    t.string "resource_type"
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "captures", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.date "capture_date"
    t.decimal "cash", precision: 16, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_user_id"
  end

  create_table "earnings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "year"
    t.integer "user_id"
    t.decimal "amount", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holdings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "ticker_id", null: false
    t.decimal "shares", precision: 16, scale: 4
    t.date "purchase_date"
    t.decimal "purchase_price", precision: 16, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticker_id", "account_id"], name: "index_holdings_on_ticker_id_and_account_id", unique: true
  end

  create_table "owners", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "account"
    t.string "brokerage"
    t.integer "account_type_id"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.decimal "price", precision: 16, scale: 4
    t.date "price_date"
    t.integer "ticker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snapshots", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "capture_id"
    t.integer "account_id"
    t.integer "ticker_id"
    t.decimal "shares", precision: 16, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 16, scale: 4
  end

  create_table "ss_adjustments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "start_year"
    t.integer "end_year"
    t.integer "full_retirement_months"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ss_factors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "year"
    t.decimal "max_earnings", precision: 16, scale: 4
    t.decimal "factor", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "ss_tax_rate", precision: 7, scale: 4
    t.decimal "medicare_tax_rate", precision: 7, scale: 4
    t.index ["year"], name: "index_ss_factors_on_year", unique: true
  end

  create_table "tickers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "maturity", precision: 5, scale: 2
    t.decimal "duration", precision: 5, scale: 2
    t.decimal "expenses", precision: 5, scale: 2
    t.string "quality"
    t.string "idx_name"
    t.string "group"
    t.string "description"
    t.string "data_link"
    t.integer "stype"
    t.string "category"
    t.decimal "aa_us_stock", precision: 6, scale: 5
    t.decimal "aa_non_us_stock", precision: 6, scale: 5
    t.decimal "aa_bond", precision: 6, scale: 5
    t.decimal "aa_cash", precision: 6, scale: 5
    t.decimal "aa_other", precision: 6, scale: 5
    t.decimal "cap_giant", precision: 6, scale: 5
    t.decimal "cap_large", precision: 6, scale: 5
    t.decimal "cap_medium", precision: 6, scale: 5
    t.decimal "cap_small", precision: 6, scale: 5
    t.decimal "cap_micro", precision: 6, scale: 5
    t.decimal "bs_government", precision: 6, scale: 5
    t.decimal "bs_corporate", precision: 6, scale: 5
    t.decimal "bs_securitized", precision: 6, scale: 5
    t.decimal "bs_municipal", precision: 6, scale: 5
    t.decimal "bs_other", precision: 6, scale: 5
    t.decimal "gov_tips", precision: 6, scale: 5
    t.decimal "gov_nominal", precision: 6, scale: 5
    t.decimal "ss_basic_material", precision: 6, scale: 5
    t.decimal "ss_consumer_cyclical", precision: 6, scale: 5
    t.decimal "ss_financial_services", precision: 6, scale: 5
    t.decimal "ss_realestate", precision: 6, scale: 5
    t.decimal "ss_communications_services", precision: 6, scale: 5
    t.decimal "ss_energy", precision: 6, scale: 5
    t.decimal "ss_industrials", precision: 6, scale: 5
    t.decimal "ss_technology", precision: 6, scale: 5
    t.decimal "ss_consumer_defensive", precision: 6, scale: 5
    t.decimal "ss_healthcare", precision: 6, scale: 5
    t.decimal "ss_utilities", precision: 6, scale: 5
    t.decimal "mr_americas", precision: 6, scale: 5
    t.decimal "mr_greater_europe", precision: 6, scale: 5
    t.decimal "mr_greater_asia", precision: 6, scale: 5
    t.decimal "mc_developed", precision: 6, scale: 5
    t.decimal "mc_emerging", precision: 6, scale: 5
    t.decimal "cq_aaa", precision: 6, scale: 5
    t.decimal "cq_aa", precision: 6, scale: 5
    t.decimal "cq_a", precision: 6, scale: 5
    t.decimal "cq_bbb", precision: 6, scale: 5
    t.decimal "cq_bb", precision: 6, scale: 5
    t.decimal "cq_b", precision: 6, scale: 5
    t.decimal "cq_below_b", precision: 6, scale: 5
    t.decimal "cq_not_rated", precision: 6, scale: 5
    t.decimal "bs_cash", precision: 6, scale: 5
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name", "date_of_birth"], name: "index_users_on_first_name_and_last_name_and_date_of_birth", unique: true
  end

end
