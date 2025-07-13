class WishlistItemsController < ApplicationController
  before_action :require_login
  before_action :set_wishlist
  before_action :set_wishlist_item, only: [:show, :edit, :update, :destroy, :mark_bought, :unmark_bought]

  def create
    @wishlist_item = @wishlist.wishlist_items.new(wishlist_item_params)
    
    if @wishlist_item.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("wishlist_items_container", 
              turbo_frame_tag("wishlist_item_#{@wishlist_item.id}") do
                render partial: "wishlist_items/item", locals: { item: @wishlist_item, wishlist: @wishlist }
              end
            ),
            turbo_stream.replace("item_count_badge", 
              partial: "wishlists/item_count", locals: { wishlist: @wishlist }),
            turbo_stream.replace("section_item_count", 
              partial: "wishlists/section_count", locals: { wishlist: @wishlist }),
            turbo_stream.replace("new_wishlist_item", 
              partial: "wishlist_items/form", locals: { wishlist: @wishlist, wishlist_item: WishlistItem.new }),
            turbo_stream.replace("empty_state", "")
          ]
        end
        format.html { redirect_to @wishlist, notice: "Item added successfully!" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_wishlist_item", 
            partial: "wishlist_items/form", locals: { wishlist: @wishlist, wishlist_item: @wishlist_item })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @wishlist_item.update(wishlist_item_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("wishlist_item_#{@wishlist_item.id}", 
            partial: "wishlist_items/item", locals: { item: @wishlist_item, wishlist: @wishlist })
        end
        format.html { redirect_to @wishlist, notice: "Item updated successfully!" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("wishlist_item_#{@wishlist_item.id}", 
            partial: "wishlist_items/edit_form", locals: { item: @wishlist_item, wishlist: @wishlist })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @wishlist_item.destroy
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("wishlist_item_#{@wishlist_item.id}"),
          turbo_stream.replace("item_count_badge", 
            partial: "wishlists/item_count", locals: { wishlist: @wishlist }),
          turbo_stream.replace("section_item_count", 
            partial: "wishlists/section_count", locals: { wishlist: @wishlist })
        ]
      end
      format.html { redirect_to @wishlist, notice: "Item deleted successfully!" }
    end
  end

  def mark_bought
    @wishlist_item.update(being_bought: true)

    # Log the gift history
    gift_history = GiftHistory.create!(
      giver: current_user,
      recipient: @wishlist.user,
      wishlist_item: @wishlist_item,
      given_at: Time.current
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("wishlist_item_#{@wishlist_item.id}", 
            partial: "wishlist_items/item", locals: { item: @wishlist_item, wishlist: @wishlist }),
          turbo_stream.broadcast_append_to(@wishlist.user, :notifications,
            partial: "notifications/gift_bought", locals: { gift_history: gift_history })
        ]
      end
      format.html { redirect_to @wishlist, notice: "Marked as bought and added to your gift history." }
    end
  end

  def unmark_bought
    @wishlist_item.update(being_bought: false)

    # Remove the corresponding GiftHistory record
    GiftHistory.where(giver: current_user, wishlist_item: @wishlist_item).destroy_all

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("wishlist_item_#{@wishlist_item.id}", 
          partial: "wishlist_items/item", locals: { item: @wishlist_item, wishlist: @wishlist })
      end
      format.html { redirect_to @wishlist, notice: "Unmarked as bought and removed from your gift history." }
    end
  end

  private

  def set_wishlist
    @wishlist = current_user.wishlists.find_by(id: params[:wishlist_id]) ||
                current_user.shared_wishlists.find_by(id: params[:wishlist_id])

    unless @wishlist
      redirect_to profile_path, alert: "You do not have access to this wishlist."
    end
  end

  def set_wishlist_item
    @wishlist_item = @wishlist.wishlist_items.find(params[:id])
  end

  def wishlist_item_params
    params.require(:wishlist_item).permit(:name, :url, :notes, :image)
  end
end