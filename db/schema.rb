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

ActiveRecord::Schema.define(version: 20171205171404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.decimal "wage", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "manager", default: false
    t.bigint "position_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "solo_associated_tip_percentage"
    t.string "location"
    t.decimal "starting_wage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "multi_associated_tip_percentage"
    t.boolean "associate_with_tip"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "shift_id"
    t.decimal "price"
    t.decimal "tip"
    t.string "method_of_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_sales_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "employee_id"
    t.datetime "finished_at"
    t.decimal "wage_earned", precision: 10, scale: 2
    t.decimal "tip_earned", precision: 10, scale: 2, default: "0.0"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "associate_with_sale"
    t.bigint "weekly_payroll_id"
    t.decimal "wage"
    t.bigint "position_id"
    t.index ["completed"], name: "index_shifts_on_completed"
    t.index ["employee_id"], name: "index_shifts_on_employee_id"
    t.index ["position_id"], name: "index_shifts_on_position_id"
    t.index ["weekly_payroll_id"], name: "index_shifts_on_weekly_payroll_id"
  end

  create_table "tip_pools", force: :cascade do |t|
    t.decimal "amount_for_employee"
    t.decimal "percentage_of_total"
    t.boolean "main_employee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shift_id"
    t.bigint "sale_id"
    t.index ["sale_id"], name: "index_tip_pools_on_sale_id"
    t.index ["shift_id"], name: "index_tip_pools_on_shift_id"
  end

  create_table "weekly_payrolls", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "week_id"
    t.decimal "total_wage", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hours_worked_per_day", default: "---\n:sunday: !ruby/object:BigDecimal 27:0.0\n:monday: !ruby/object:BigDecimal 27:0.0\n:tuesday: !ruby/object:BigDecimal 27:0.0\n:wednesday: !ruby/object:BigDecimal 27:0.0\n:thursday: !ruby/object:BigDecimal 27:0.0\n:friday: !ruby/object:BigDecimal 27:0.0\n:saturday: !ruby/object:BigDecimal 27:0.0\n"
    t.index ["employee_id", "week_id"], name: "index_weekly_payrolls_on_employee_id_and_week_id", unique: true
    t.index ["employee_id"], name: "index_weekly_payrolls_on_employee_id"
    t.index ["week_id"], name: "index_weekly_payrolls_on_week_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.datetime "date_started"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_started"], name: "index_weeks_on_date_started", unique: true
  end

  add_foreign_key "employees", "positions"
  add_foreign_key "shifts", "positions"
  add_foreign_key "tip_pools", "sales"
  add_foreign_key "tip_pools", "shifts"
end
