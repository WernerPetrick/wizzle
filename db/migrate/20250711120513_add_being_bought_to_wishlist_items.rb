class AddBeingBoughtToWishlistItems < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlist_items, :being_bought, :boolean
  end
end
