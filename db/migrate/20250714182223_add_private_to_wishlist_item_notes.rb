class AddPrivateToWishlistItemNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlist_item_notes, :private, :boolean
  end
end
