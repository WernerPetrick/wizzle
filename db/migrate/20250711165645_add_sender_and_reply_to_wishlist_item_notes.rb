class AddSenderAndReplyToWishlistItemNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlist_item_notes, :sender_id, :integer
    add_column :wishlist_item_notes, :owner_reply, :text
  end
end
