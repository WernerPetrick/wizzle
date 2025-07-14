class AddPublicTokenToWishlists < ActiveRecord::Migration[8.0]
  def change
    add_column :wishlists, :public_token, :string
    add_index :wishlists, :public_token, unique: true
  end
end
