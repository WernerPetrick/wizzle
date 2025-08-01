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

ActiveRecord::Schema[8.0].define(version: 2025_08_01_140951) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :serial, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :serial, force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.boolean "published"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "community_events", force: :cascade do |t|
    t.bigint "community_id", null: false
    t.string "title", null: false
    t.text "description"
    t.date "event_date", null: false
    t.string "event_type", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_events_on_community_id"
    t.index ["created_by_id"], name: "index_community_events_on_created_by_id"
    t.index ["event_date"], name: "index_community_events_on_event_date"
    t.index ["event_type"], name: "index_community_events_on_event_type"
  end

  create_table "community_events_wishlists", force: :cascade do |t|
    t.bigint "community_event_id", null: false
    t.bigint "wishlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_event_id"], name: "index_community_events_wishlists_on_community_event_id"
    t.index ["wishlist_id"], name: "index_community_events_wishlists_on_wishlist_id"
  end

  create_table "community_invitations", force: :cascade do |t|
    t.integer "community_id"
    t.integer "inviter_id"
    t.integer "invitee_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "community_memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "community_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", id: :serial, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status"
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "gift_histories", id: :serial, force: :cascade do |t|
    t.integer "giver_id"
    t.integer "recipient_id"
    t.integer "wishlist_item_id"
    t.datetime "given_at", precision: nil
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.string "email"
    t.integer "inviter_id"
    t.string "token"
    t.boolean "accepted"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "roadmap_items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "status"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "secret_santa_assignments", force: :cascade do |t|
    t.bigint "secret_santa_id", null: false
    t.bigint "giver_id", null: false
    t.bigint "receiver_id", null: false
    t.boolean "gift_purchased", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["giver_id"], name: "index_secret_santa_assignments_on_giver_id"
    t.index ["receiver_id"], name: "index_secret_santa_assignments_on_receiver_id"
    t.index ["secret_santa_id", "giver_id"], name: "index_secret_santa_assignments_on_secret_santa_id_and_giver_id", unique: true
    t.index ["secret_santa_id", "receiver_id"], name: "idx_on_secret_santa_id_receiver_id_63b79ec3fa", unique: true
    t.index ["secret_santa_id"], name: "index_secret_santa_assignments_on_secret_santa_id"
  end

  create_table "secret_santas", force: :cascade do |t|
    t.bigint "community_id", null: false
    t.bigint "created_by_id", null: false
    t.string "title", null: false
    t.text "description"
    t.date "event_date", null: false
    t.date "reveal_date"
    t.decimal "budget_limit", precision: 8, scale: 2
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_secret_santas_on_community_id"
    t.index ["created_by_id"], name: "index_secret_santas_on_created_by_id"
    t.index ["event_date"], name: "index_secret_santas_on_event_date"
    t.index ["status"], name: "index_secret_santas_on_status"
  end

  create_table "shared_wishlists", id: :serial, force: :cascade do |t|
    t.bigint "wishlist_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_shared_wishlists_on_user_id"
    t.index ["wishlist_id"], name: "index_shared_wishlists_on_wishlist_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "name"
    t.boolean "notify_friend_invite"
    t.boolean "notify_wishlist_question"
    t.boolean "notify_question_reply"
    t.date "birthday"
    t.boolean "admin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  create_table "wishlist_item_notes", id: :serial, force: :cascade do |t|
    t.bigint "wishlist_item_id", null: false
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "sender_id"
    t.text "owner_reply"
    t.boolean "private"
    t.boolean "seen"
    t.index ["wishlist_item_id"], name: "index_wishlist_item_notes_on_wishlist_item_id"
  end

  create_table "wishlist_items", id: :serial, force: :cascade do |t|
    t.bigint "wishlist_id", null: false
    t.string "name"
    t.string "url"
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "being_bought"
    t.index ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id"
  end

  create_table "wishlists", id: :serial, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "public_token"
    t.boolean "private"
    t.index ["public_token"], name: "index_wishlists_on_public_token", unique: true
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "blog_posts", "users"
  add_foreign_key "community_events", "communities"
  add_foreign_key "community_events", "users", column: "created_by_id"
  add_foreign_key "community_events_wishlists", "community_events"
  add_foreign_key "community_events_wishlists", "wishlists"
  add_foreign_key "secret_santa_assignments", "secret_santas"
  add_foreign_key "secret_santa_assignments", "users", column: "giver_id"
  add_foreign_key "secret_santa_assignments", "users", column: "receiver_id"
  add_foreign_key "secret_santas", "communities"
  add_foreign_key "secret_santas", "users", column: "created_by_id"
end
