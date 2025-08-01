class CreateSecretSantas < ActiveRecord::Migration[8.0]
  def change
    create_table :secret_santas do |t|
      t.references :community, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description
      t.date :event_date, null: false
      t.date :reveal_date
      t.decimal :budget_limit, precision: 8, scale: 2
      t.string :status, default: 'draft'

      t.timestamps
    end

    add_index :secret_santas, :event_date
    add_index :secret_santas, :status
  end
end