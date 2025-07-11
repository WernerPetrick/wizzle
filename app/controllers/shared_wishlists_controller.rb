class SharedWishlistsController < ApplicationController
  before_action :require_login

  def create
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
    emails = params[:emails].to_s.split(/[\r\n,]+/).map(&:strip).reject(&:blank?)
    invited = []
    not_found = []

    emails.each do |email|
      friend = User.find_by(email: email)
      if friend && friend != current_user
        @wishlist.shared_users << friend unless @wishlist.shared_users.include?(friend)
        invited << email
      else
        not_found << email
      end
    end

    message = if not_found.any?
      "Some users not found: #{not_found.join(', ')}. Others invited: #{invited.join(', ')}"
    else
      "Invited: #{invited.join(', ')}"
    end

    flash[:notice] = message

    respond_to do |format|
      format.html { redirect_to @wishlist }
      format.wizzle_flash { render partial: "layouts/flash" }
    end
  end

  def destroy
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
    friend = User.find(params[:id])
    @wishlist.shared_users.delete(friend)
    redirect_to @wishlist, notice: "Access revoked for #{friend.email}"
  end
end