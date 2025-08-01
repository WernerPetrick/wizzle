class CreateCommunityInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :community_invitations do |t|
      t.integer :community_id
      t.integer :inviter_id
      t.integer :invitee_id
      t.string :status

      t.timestamps
    end
  end
end
