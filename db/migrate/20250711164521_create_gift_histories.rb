class CreateGiftHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :gift_histories do |t|
      t.integer :giver_id
      t.integer :recipient_id
      t.integer :wishlist_item_id
      t.datetime :given_at
      t.text :notes

      t.timestamps
    end
  end
end
