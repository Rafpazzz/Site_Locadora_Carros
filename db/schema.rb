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

ActiveRecord::Schema[8.0].define(version: 2025_11_10_175012) do
  create_table "carros", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", limit: 50, null: false
    t.string "cor", limit: 50, null: false
    t.date "ano", null: false
    t.string "marca", limit: 50, null: false
    t.string "combustivel", limit: 50
    t.string "cambio", limit: 50, null: false
    t.boolean "isDisponivel", default: true, null: false
    t.string "placa", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor_diaria", precision: 10, default: "0", null: false
  end

  create_table "emprestimos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "locatario_id"
    t.bigint "carro_id", null: false
    t.datetime "data_inicio", null: false
    t.datetime "data_fim", null: false
    t.datetime "data_devolucao"
    t.decimal "valor_total", precision: 10
    t.string "status", default: "Locado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carro_id"], name: "index_emprestimos_on_carro_id"
    t.index ["locatario_id"], name: "index_emprestimos_on_locatario_id"
  end

  create_table "locatarios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome", null: false
    t.string "cpf", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_locatarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_locatarios_on_reset_password_token", unique: true
  end

  add_foreign_key "emprestimos", "carros"
  add_foreign_key "emprestimos", "locatarios"
end
