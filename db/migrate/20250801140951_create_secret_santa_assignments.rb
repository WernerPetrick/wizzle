class CreateSecretSantaAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :secret_santa_assignments do |t|
      t.references :secret_santa, null: false, foreign_key: { to_table: :secret_santas }
      t.references :giver, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.boolean :gift_purchased, default: false

      t.timestamps
    end

    add_index :secret_santa_assignments, [:secret_santa_id, :giver_id], unique: true
    add_index :secret_santa_assignments, [:secret_santa_id, :receiver_id], unique: true
  end
end