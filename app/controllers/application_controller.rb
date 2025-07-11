class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_pending_friend_invites
  before_action :set_new_wishlist_item_notes
  

  def after_sign_in_path_for(_user)
    profile_path
  end

  private

  def set_pending_friend_invites
    if signed_in?
      @pending_friend_invites_count = Friendship.where(friend: current_user, status: "pending").count
    end
  end

  def set_new_wishlist_item_notes
    if signed_in?
      # Count notes for items owned by current_user that have not been replied to
      @new_wishlist_item_notes_count = WishlistItemNote.joins(wishlist_item: :wishlist)
        .where(wishlist_items: { wishlist_id: current_user.wishlists.pluck(:id) })
        .where(owner_reply: [nil, ""])
        .count
    end
  end
end
