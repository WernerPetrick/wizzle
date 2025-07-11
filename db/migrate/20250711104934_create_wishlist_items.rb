class CreateWishlistItems < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlist_items do |t|
      t.references :wishlist, null: false, foreign_key: true
      t.string :name
      t.string :url
      t.text :notes

      t.timestamps
    end
  end
end
