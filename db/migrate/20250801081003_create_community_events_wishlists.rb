class CreateCommunityEventsWishlists < ActiveRecord::Migration[8.0]
  def change
    create_table :community_events_wishlists do |t|
      t.references :community_event, null: false, foreign_key: true
      t.references :wishlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
