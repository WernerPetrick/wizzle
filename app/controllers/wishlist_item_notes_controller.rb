class WishlistItemNotesController < ApplicationController
  before_action :require_login

  def create
    @wishlist_item = WishlistItem.find(params[:wishlist_item_id])
    @note = @wishlist_item.wishlist_item_notes.create(
      body: params[:body],
      sender: current_user,
      private: params[:private] == "1"
    )
    owner = @wishlist_item.wishlist.user
    if owner.notify_wishlist_question?
      WishlistItemNoteMailer.notify_owner(@note).deliver_now
    end
    redirect_to wishlist_path(@wishlist_item.wishlist), notice: "Your anonymous note was sent!"
  end

  def reply
    @note = WishlistItemNote.find(params[:id])
    if @note.wishlist_item.wishlist.user == current_user
      @note.update(owner_reply: params[:owner_reply])
      sender = @note.sender
      if sender && sender.notify_question_reply?
        WishlistItemNoteMailer.notify_sender(@note).deliver_now
      end
    end
    redirect_to wishlist_path(@note.wishlist_item.wishlist), notice: "Reply sent."
  end

end
