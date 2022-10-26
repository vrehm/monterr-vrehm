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

ActiveRecord::Schema.define(version: 2022_10_12_121627) do

  create_table "commune_streets", force: :cascade do |t|
    t.integer "street_id", null: false
    t.integer "commune_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commune_id"], name: "index_commune_streets_on_commune_id"
    t.index ["street_id"], name: "index_commune_streets_on_street_id"
  end

  create_table "communes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "population"
    t.string "code_insee", null: false
    t.integer "intercommunality_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_insee"], name: "index_communes_on_code_insee", unique: true
    t.index ["intercommunality_id"], name: "index_communes_on_intercommunality_id"
  end

  create_table "intercommunalities", force: :cascade do |t|
    t.string "form"
    t.string "name", null: false
    t.integer "population"
    t.string "siren", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["siren"], name: "index_intercommunalities_on_siren", unique: true
  end

  create_table "streets", force: :cascade do |t|
    t.string "title", null: false
    t.integer "from"
    t.integer "to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_streets_on_title"
  end

  add_foreign_key "commune_streets", "communes"
  add_foreign_key "commune_streets", "streets"
  add_foreign_key "communes", "intercommunalities"
end
