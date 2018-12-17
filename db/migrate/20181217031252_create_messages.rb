class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :academico, foreign_key: true
      t.references :conversation, foreign_key: true

      t.timestamps
    end
  end
end
