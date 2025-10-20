class CreateLocatarios < ActiveRecord::Migration[8.0]
  def change
    create_table :locatarios do |t|
      t.string :nome, null: false
      t.string :cpf, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
