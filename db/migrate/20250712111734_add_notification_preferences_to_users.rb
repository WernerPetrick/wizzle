class AddNotificationPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notify_friend_invite, :boolean
    add_column :users, :notify_wishlist_question, :boolean
    add_column :users, :notify_question_reply, :boolean
  end
end
