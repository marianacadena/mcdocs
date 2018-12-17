class CreateFirmaElectronicas < ActiveRecord::Migration[5.2]
  def change
    create_table :firma_electronicas do |t|
      t.text :publicSSLKey
      t.string :public_key_file
      t.references :academico, foreign_key: true

      t.timestamps
    end
  end
end
