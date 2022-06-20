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

ActiveRecord::Schema.define(version: 2022_06_20_053527) do

  create_table "carriers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "active_flg", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "computings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "range", null: false
    t.string "dem_det", null: false
    t.integer "price", null: false
    t.integer "container_type", null: false
    t.integer "from", null: false
    t.integer "to", null: false
    t.string "port", null: false
    t.bigint "carrier_id"
    t.bigint "free_calc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_computings_on_carrier_id"
    t.index ["free_calc_id"], name: "index_computings_on_free_calc_id"
  end

  create_table "free_calcs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "free_day", null: false
    t.integer "calc_method", null: false
    t.integer "start_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tariffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "calc", default: "", null: false
    t.string "free", default: "", null: false
    t.string "first_from", default: "1", null: false
    t.string "first_to", default: "999", null: false
    t.string "first_amount", default: "0", null: false
    t.string "second_from", default: "999", null: false
    t.string "second_to", default: "999", null: false
    t.string "second_amount", default: "0", null: false
    t.string "third_from", default: "999", null: false
    t.string "third_to", default: "999", null: false
    t.string "third_amount", default: "0", null: false
    t.string "fourth_from", default: "999", null: false
    t.string "fourth_to", default: "999", null: false
    t.string "fourth_amount", default: "0", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tariffs_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "computings", "carriers"
  add_foreign_key "computings", "free_calcs"
  add_foreign_key "tariffs", "users"
end
