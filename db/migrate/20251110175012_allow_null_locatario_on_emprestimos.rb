class AllowNullLocatarioOnEmprestimos < ActiveRecord::Migration[8.0]
  def change
    change_column_null :emprestimos, :locatario_id, true
  end
end
