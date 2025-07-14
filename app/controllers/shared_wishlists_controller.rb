class SharedWishlistsController < ApplicationController
  before_action :require_login

  def create
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
    friend_ids = params[:friend_ids] || []
    invited = []
    not_found = []

    friend_ids.each do |id|
      friend = User.find_by(id: id)
      if friend && friend != current_user
        @wishlist.shared_users << friend unless @wishlist.shared_users.include?(friend)
        invited << friend.email
      else
        not_found << id
      end
    end

    message = if not_found.any?
      "Some users not found: #{not_found.join(', ')}. Others invited: #{invited.join(', ')}"
    else
      "Invited: #{invited.join(', ')}"
    end

    flash[:notice] = message
    redirect_to @wishlist
  end

  def destroy
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
    friend = User.find(params[:id])
    @wishlist.shared_users.delete(friend)
    redirect_to @wishlist, notice: "Access revoked for #{friend.email}"
  end
end