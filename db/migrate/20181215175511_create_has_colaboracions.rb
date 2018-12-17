class CreateHasColaboracions < ActiveRecord::Migration[5.2]
  def change
    create_table :has_colaboracions do |t|
      t.references :academico, foreign_key: true
      t.references :documento, foreign_key: true

      t.timestamps
    end
  end
end
