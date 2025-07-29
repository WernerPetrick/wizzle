class CreateRoadmapItems < ActiveRecord::Migration[8.0]
  def change
    create_table :roadmap_items do |t|
      t.string :title
      t.text :description
      t.string :status
      t.integer :position

      t.timestamps
    end
  end
end
