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

ActiveRecord::Schema[8.0].define(version: 2025_12_14_015317) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_analytics_views_per_days", force: :cascade do |t|
    t.string "site", null: false
    t.string "page", null: false
    t.date "date", null: false
    t.bigint "total", default: 1, null: false
    t.string "referrer_host"
    t.string "referrer_path"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["date", "site", "page"], name: "index_active_analytics_views_per_days_on_date_and_site_and_page"
    t.index ["date", "site", "referrer_host", "referrer_path"], name: "index_views_per_days_on_date_site_referrer_host_referrer_path"
  end

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

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "case_solutions", force: :cascade do |t|
    t.bigint "case_id", null: false
    t.bigint "solution_id", null: false
    t.integer "match_score", null: false
    t.datetime "presented_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id", "solution_id"], name: "index_case_solutions_on_case_id_and_solution_id", unique: true
    t.index ["case_id"], name: "index_case_solutions_on_case_id"
    t.index ["match_score"], name: "index_case_solutions_on_match_score"
    t.index ["solution_id"], name: "index_case_solutions_on_solution_id"
  end

  create_table "cases", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.bigint "user_id"
    t.text "problem_description", null: false
    t.text "tried_solutions"
    t.integer "knowledge_level"
    t.string "status", default: "open", null: false
    t.string "access_token", null: false
    t.string "access_code", null: false
    t.string "affected_boards", default: [], array: true
    t.string "baldrick_version"
    t.string "fpp_version"
    t.string "xlights_version"
    t.string "operating_system"
    t.text "system_state"
    t.text "fpp_outputs_state"
    t.bigint "solved_by_solution_id"
    t.integer "case_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "custom_solution"
    t.text "problem_summary"
    t.index ["access_token"], name: "index_cases_on_access_token", unique: true
    t.index ["case_number"], name: "index_cases_on_case_number", unique: true
    t.index ["email"], name: "index_cases_on_email"
    t.index ["status"], name: "index_cases_on_status"
    t.index ["user_id"], name: "index_cases_on_user_id"
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

  create_table "error_logs", force: :cascade do |t|
    t.string "url"
    t.string "referrer"
    t.string "user_agent"
    t.string "ip"
    t.integer "count"
    t.datetime "last_seen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "solutions", force: :cascade do |t|
    t.string "problem_keywords", default: [], array: true
    t.string "problem_title", null: false
    t.text "solution_text", null: false
    t.string "board_types", default: [], array: true
    t.boolean "active", default: true, null: false
    t.integer "match_count", default: 0, null: false
    t.integer "success_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_solutions_on_active"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "case_solutions", "cases"
  add_foreign_key "case_solutions", "solutions"
  add_foreign_key "cases", "solutions", column: "solved_by_solution_id"
end
