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

ActiveRecord::Schema.define(version: 20151020144029) do
ActiveRecord::Schema.define(version: 20151022155057) do

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.string   "images"
    t.boolean  "post_status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "imgs"
  end

  create_table "tag_haves", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tag_haves", ["post_id"], name: "index_tag_haves_on_post_id"
  add_index "tag_haves", ["tag_id"], name: "index_tag_haves_on_tag_id"

  create_table "tag_wants", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tag_wants", ["post_id"], name: "index_tag_wants_on_post_id"
  add_index "tag_wants", ["tag_id"], name: "index_tag_wants_on_tag_id"

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "gender"
    t.string   "avatar"
    t.datetime "last_login"
    t.date     "birthday"
    t.string   "tel"
    t.string   "skype"
    t.string   "facebook"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
  end

end
