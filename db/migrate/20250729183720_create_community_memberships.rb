class CreateCommunityMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :community_memberships do |t|
      t.integer :user_id
      t.integer :community_id
      t.string :role

      t.timestamps
    end
  end
end
