class CreateCommunityEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :community_events do |t|
      t.references :community, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.date :event_date, null: false
      t.string :event_type, null: false
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :community_events, :event_date
    add_index :community_events, :event_type
  end
end