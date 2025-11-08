class RevertDecimalColumnsFix < ActiveRecord::Migration[8.0] # (ou sua versão)
  def change
    # Revertendo a coluna 'valor_total' para não aceitar casas decimais
    change_column :emprestimos, :valor_total, :decimal, precision: 10, scale: 0

    # Revertendo a coluna 'valor_diaria' para não aceitar casas decimais
    change_column :carros, :valor_diaria, :decimal, precision: 10, scale: 0
  end
end
