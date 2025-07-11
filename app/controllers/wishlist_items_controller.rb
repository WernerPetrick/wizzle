class WishlistItemsController < ApplicationController
  before_action :require_login
  before_action :set_wishlist

  def new
    @wishlist_item = @wishlist.wishlist_items.new
  end

  def create
    @wishlist_item = @wishlist.wishlist_items.new(wishlist_item_params)
    if @wishlist_item.save
      redirect_to @wishlist, notice: "Item added!"
    else
      render :new
    end
  end

  def edit
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item = @wishlist.wishlist_items.find(params[:id])
  end

  def update
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item = @wishlist.wishlist_items.find(params[:id])
    if @item.update(wishlist_item_params)
      redirect_to wishlist_path(@wishlist), notice: "Item updated."
    else
      render :edit
    end
  end

  def destroy
    @wishlist_item = @wishlist.wishlist_items.find(params[:id])
    @wishlist_item.destroy
    redirect_to @wishlist, notice: "Item deleted."
  end

  def mark_bought
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item = @wishlist.wishlist_items.find(params[:id])
    @item.update(being_bought: true)

    # Log the gift history
    GiftHistory.create!(
      giver: current_user,
      recipient: @wishlist.user,
      wishlist_item: @item,
      given_at: Time.current
    )

    redirect_to wishlist_path(@wishlist), notice: "Marked as bought and added to your gift history."
  end

  def unmark_bought
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item = @wishlist.wishlist_items.find(params[:id])
    @item.update(being_bought: false)

    # Remove the corresponding GiftHistory record
    GiftHistory.where(
      giver: current_user,
      recipient: @wishlist.user,
      wishlist_item: @item
    ).destroy_all

    redirect_to wishlist_path(@wishlist), notice: "Marked as not bought and removed from your gift history."
  end

  private

  def set_wishlist
    @wishlist = current_user.wishlists.find_by(id: params[:wishlist_id]) ||
                current_user.wishlists_shared_with_me.find_by(id: params[:wishlist_id])
    unless @wishlist
      redirect_to profile_path, alert: "You do not have access to this wishlist."
    end
  end

  def wishlist_item_params
    params.require(:wishlist_item).permit(:name, :url, :notes)
  end
end