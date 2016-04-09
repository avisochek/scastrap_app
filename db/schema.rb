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

ActiveRecord::Schema.define(version: 20160304040055) do

  create_table "batches", id: false, force: :cascade do |t|
    t.integer  "id_",        null: false
    t.datetime "created_at", null: false
    t.integer  "city_id"
    t.datetime "updated_at", null: false
  end

  create_table "cities", id: false, force: :cascade do |t|
    t.integer  "id_",        null: false
    t.integer  "lat"
    t.integer  "lng"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clusters", id: false, force: :cascade do |t|
    t.integer  "id_",             null: false
    t.integer  "request_type_id"
    t.integer  "city_id"
    t.integer  "score"
    t.integer  "batch_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "clusters", ["batch_id"], name: "index_clusters_on_batch_id"
  add_index "clusters", ["city_id"], name: "index_clusters_on_city_id"
  add_index "clusters", ["request_type_id"], name: "index_clusters_on_request_type_id"

  create_table "clusters_issues", force: :cascade do |t|
    t.integer  "cluster_id"
    t.integer  "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", id: false, force: :cascade do |t|
    t.integer  "id_",             null: false
    t.integer  "request_type_id"
    t.integer  "city_id"
    t.integer  "street_id"
    t.datetime "created_at",      null: false
    t.string   "status"
    t.string   "address"
    t.string   "description"
    t.string   "summary"
    t.float    "lng"
    t.float    "lat"
    t.datetime "updated_at",      null: false
  end

  add_index "issues", ["city_id"], name: "index_issues_on_city_id"
  add_index "issues", ["request_type_id"], name: "index_issues_on_request_type_id"
  add_index "issues", ["street_id"], name: "index_issues_on_street_id"

  create_table "request_types", id: false, force: :cascade do |t|
    t.integer  "id_",        null: false
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "request_types", ["city_id"], name: "index_request_types_on_city_id"

  create_table "streets", force: :cascade do |t|
    t.integer  "id_",        null: false
    t.string   "name"
    t.integer  "city_id"
    t.float    "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "streets", ["city_id"], name: "index_streets_on_city_id"

end
