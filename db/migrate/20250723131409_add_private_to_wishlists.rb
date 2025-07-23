class AddPrivateToWishlists < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlists, :private, :boolean
  end
end
