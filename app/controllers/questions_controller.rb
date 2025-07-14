class QuestionsController < ApplicationController
  before_action :require_login

  def index
    # Find all wishlist items owned by the current user
    wishlist_item_ids = WishlistItem.joins(:wishlist)
      .where(wishlists: { user_id: current_user.id })
      .pluck(:id)

    # Find all notes for those items that have not been replied to
    @notes = WishlistItemNote.where(wishlist_item_id: wishlist_item_ids, owner_reply: [nil, ""])
      .includes(:wishlist_item)
      .order(created_at: :desc)

    # Mark these notes as seen
    WishlistItemNote.where(id: @notes.map(&:id)).update_all(seen: true)
  end
end