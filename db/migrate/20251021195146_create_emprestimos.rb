class CreateEmprestimos < ActiveRecord::Migration[8.0]
  def change
    create_table :emprestimos do |t|
      t.references :locatario, null: false, foreign_key: true
      t.references :carro, null: false, foreign_key: true

      t.datetime :data_inicio, null: false
      t.datetime :data_fim, null: false
      t.datetime :data_devolucao
      t.decimal :valor_total, precision: 10, scale: 2
      t.string :status, default: 'Locado'

      t.timestamps
    end
  end
end
