class AddAdminToLocatarios < ActiveRecord::Migration[8.0]
  def change
    add_column :locatarios, :admin, :boolean, default: false, null: false
  end
end
