class CreateWishlistItemNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlist_item_notes do |t|
      t.references :wishlist_item, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
