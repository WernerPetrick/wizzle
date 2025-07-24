class ApplicationController < ActionController::Base
  include Clearance::Controller
  before_action :set_pending_friend_invites
  before_action :set_new_wishlist_item_notes
  before_action :set_latest_news
  

  def after_sign_in_path_for(_user)
    profile_path
  end

  private

  def set_latest_news
    @latest_news = "New: Wishlists are now public by default."
  end

  def set_pending_friend_invites
    if signed_in?
      @pending_friend_invites_count = Friendship.where(friend: current_user, status: "pending").count
    end
  end

  def set_new_wishlist_item_notes
    if signed_in?
      @new_wishlist_item_notes_count = WishlistItemNote.joins(wishlist_item: :wishlist)
        .where(wishlist_items: { wishlist_id: current_user.wishlists.pluck(:id) })
        .where(owner_reply: [nil, ""])
        .where(seen: [false, nil])
        .count
    end
  end
end
