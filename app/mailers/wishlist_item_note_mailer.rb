class WishlistItemNoteMailer < ApplicationMailer
  def notify_owner(note)
    @note = note
    @wishlist_item = note.wishlist_item
    @owner = @wishlist_item.wishlist.user
    @sender = note.sender
    mail(
      to: @owner.email,
      subject: "New question about your wishlist item: #{@wishlist_item.name}"
    )
  end

  def notify_sender(note)
    @note = note
    @wishlist_item = note.wishlist_item
    @owner = @wishlist_item.wishlist.user
    @sender = note.sender
    mail(
      to: @sender.email,
      subject: "Your question about '#{@wishlist_item.name}' has been answered!"
    )
  end

end