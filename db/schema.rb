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

ActiveRecord::Schema.define(version: 2019_03_06_105926) do

  create_table "amount_used_of_credits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "using_border", null: false
    t.integer "withdrawal_amount", null: false
    t.bigint "credit_card_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "withdrawal_date"
    t.index ["credit_card_id"], name: "index_amount_used_of_credits_on_credit_card_id"
    t.index ["user_id"], name: "index_amount_used_of_credits_on_user_id"
  end

  create_table "asset_transitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_amount", null: false
    t.date "date", null: false
    t.bigint "user_asset_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_asset_id"], name: "index_asset_transitions_on_user_asset_id"
    t.index ["user_id"], name: "index_asset_transitions_on_user_id"
  end

  create_table "credit_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.date "use_period", null: false
    t.integer "use_border", null: false
    t.string "withdrawal_date", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "debts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.integer "debt_total_amount", null: false
    t.integer "withdrawal_amount", null: false
    t.string "withdrawal_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "incomes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.integer "income_amount", null: false
    t.date "income_date", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "item_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_type", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.integer "price", null: false
    t.string "image_url"
    t.date "date"
    t.bigint "item_type_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type_id"], name: "index_items_on_item_type_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "monthly_flows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "monthly_income_in_sum", null: false
    t.integer "month_disbursement_sum", null: false
    t.string "year", null: false
    t.string "month", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_monthly_flows_on_user_id"
  end

  create_table "user_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_assets_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "amount_used_of_credits", "credit_cards"
  add_foreign_key "amount_used_of_credits", "users"
  add_foreign_key "asset_transitions", "user_assets"
  add_foreign_key "asset_transitions", "users"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "debts", "users"
  add_foreign_key "incomes", "users"
  add_foreign_key "items", "item_types"
  add_foreign_key "items", "users"
  add_foreign_key "monthly_flows", "users"
  add_foreign_key "user_assets", "users"
end
