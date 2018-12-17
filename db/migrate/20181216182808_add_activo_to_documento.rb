class AddActivoToDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :documentos, :activo, :integer
  end
end
