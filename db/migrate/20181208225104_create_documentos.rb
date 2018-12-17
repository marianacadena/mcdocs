class CreateDocumentos < ActiveRecord::Migration[5.2]
  def change
    create_table :documentos do |t|
      t.string :nombre
      t.string :formato
      t.references :academico, foreign_key: true

      t.timestamps
    end
  end
end
