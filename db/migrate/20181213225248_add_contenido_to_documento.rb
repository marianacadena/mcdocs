class AddContenidoToDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :documentos, :contenido, :text
  end
end
