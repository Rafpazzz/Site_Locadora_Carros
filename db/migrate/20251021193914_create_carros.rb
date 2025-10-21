class CreateCarros < ActiveRecord::Migration[8.0]
  def change
    create_table :carros do |t|
      t.string :nome, null: false, limit: 50
      t.string :cor, null: false, limit: 50
      t.date :ano, null: false
      t.string :marca, null: false, limit: 50
      t.string :combustivel, limit: 50
      t.string :cambio, limit: 50, null: false
      t.boolean :isDisponivel, null: false, default: 'Disponivel'
      t.string :placa, limit: 10, null:false

      t.timestamps
    end
  end
end
