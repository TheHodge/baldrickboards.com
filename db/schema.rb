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

ActiveRecord::Schema[8.0].define(version: 2025_09_07_121713) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "subject", null: false
    t.text "message", null: false
    t.string "status", default: "new"
    t.boolean "email_sent", default: false
    t.datetime "email_sent_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_contacts_on_created_at"
    t.index ["email"], name: "index_contacts_on_email"
    t.index ["status"], name: "index_contacts_on_status"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "feedback_type", null: false
    t.text "content", null: false
    t.string "status", default: "new"
    t.boolean "processed", default: false
    t.datetime "processed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_feedbacks_on_created_at"
    t.index ["feedback_type"], name: "index_feedbacks_on_feedback_type"
    t.index ["processed"], name: "index_feedbacks_on_processed"
    t.index ["status"], name: "index_feedbacks_on_status"
  end

  create_table "newsletter_subscribers", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "subscribed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_newsletter_subscribers_on_email", unique: true
  end

  create_table "search_logs", force: :cascade do |t|
    t.string "query", null: false
    t.string "result_url"
    t.string "result_title"
    t.boolean "clicked", default: false
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clicked"], name: "index_search_logs_on_clicked"
    t.index ["created_at"], name: "index_search_logs_on_created_at"
    t.index ["query", "clicked"], name: "index_search_logs_on_query_and_clicked"
    t.index ["query"], name: "index_search_logs_on_query"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
