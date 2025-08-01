module CommunityEventsHelper
  def wishlist_checked?(wishlist, event)
    event&.persisted? && event.wishlists.include?(wishlist)
  end
end