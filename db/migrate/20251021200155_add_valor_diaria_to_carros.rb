class AddValorDiariaToCarros < ActiveRecord::Migration[8.0]
  def change
    add_column :carros, :valor_diaria, :double, null: false, default: 0.0
  end
end
