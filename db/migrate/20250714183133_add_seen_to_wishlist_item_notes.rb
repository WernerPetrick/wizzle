class AddSeenToWishlistItemNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlist_item_notes, :seen, :boolean
  end
end
