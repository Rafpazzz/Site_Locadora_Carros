class FixDecimalColumns < ActiveRecord::Migration[8.0] # (ou sua versão)
  def change
    # 1. Altera a coluna 'valor_total' na tabela 'emprestimos'
    change_column :emprestimos, :valor_total, :decimal, precision: 10, scale: 2

    # 2. Altera a coluna 'valor_diaria' na tabela 'carros'
    change_column :carros, :valor_diaria, :decimal, precision: 10, scale: 2
  end
end