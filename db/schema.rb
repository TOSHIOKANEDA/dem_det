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

ActiveRecord::Schema.define(version: 2022_05_20_094946) do

  create_table "carriers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "range", null: false
    t.string "dem_det", null: false
    t.integer "price", null: false
    t.integer "container_type", null: false
    t.integer "from", null: false
    t.integer "to", null: false
    t.string "port", null: false
    t.integer "free", null: false
    t.integer "calc", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
