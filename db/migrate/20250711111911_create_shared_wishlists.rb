class CreateSharedWishlists < ActiveRecord::Migration[8.0]
  def change
    create_table :shared_wishlists do |t|
      t.references :wishlist, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
