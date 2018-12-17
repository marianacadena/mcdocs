class AddLockableToDevise < ActiveRecord::Migration[5.2]
  def change
    add_column :academicos, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :academicos, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :academicos, :locked_at, :datetime
    add_index :academicos, :unlock_token, unique: true
  end
end
