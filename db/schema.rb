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

ActiveRecord::Schema.define(version: 20180812104733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.integer "project_id"
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "slug"
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "message"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "body"
    t.string "status"
    t.string "feature_image"
    t.datetime "created_at", null: false
    t.string "category"
    t.bigint "tags_id"
    t.bigint "user_id"
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["tags_id"], name: "index_posts_on_tags_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "project_images", force: :cascade do |t|
    t.integer "project_id"
    t.string "image_url"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "status"
    t.string "description"
    t.string "caption"
    t.string "milestones"
    t.string "repo_url"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feature_image"
    t.string "project_url"
    t.string "technical_information"
    t.bigint "comments_id"
    t.bigint "project_images_id"
    t.bigint "tags_id"
    t.index ["comments_id"], name: "index_projects_on_comments_id"
    t.index ["project_images_id"], name: "index_projects_on_project_images_id"
    t.index ["tags_id"], name: "index_projects_on_tags_id"
  end

  create_table "references", force: :cascade do |t|
    t.string "title"
    t.string "name"
    t.string "avatar"
    t.string "body"
    t.string "company"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.string "status"
    t.index ["project_id"], name: "index_tags_on_project_id"
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer "project_id"
    t.integer "comment_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "admin"
    t.string "password_digest"
    t.string "profile_picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_reset"
    t.boolean "confirmed"
    t.string "confirm_token"
  end

  add_foreign_key "posts", "tags", column: "tags_id"
  add_foreign_key "posts", "users"
  add_foreign_key "projects", "comments", column: "comments_id"
  add_foreign_key "projects", "project_images", column: "project_images_id"
  add_foreign_key "projects", "tags", column: "tags_id"
  add_foreign_key "tags", "projects"
end
