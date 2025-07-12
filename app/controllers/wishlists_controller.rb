class WishlistsController < ApplicationController
  before_action :require_login
  before_action :require_owner, only: [:destroy, :add_items]

  def new
    @wishlist = current_user.wishlists.new
    5.times { @wishlist.wishlist_items.build }
  end

  def create
    @wishlist = current_user.wishlists.new(wishlist_params)
    if @wishlist.save
      redirect_to @wishlist, notice: "Wishlist created!"
    else
      render :new
    end
  end

  def show
    @wishlist = current_user.wishlists.find_by(id: params[:id]) ||
                current_user.wishlists_shared_with_me.find_by(id: params[:id])
    if @wishlist.nil?
      redirect_to profile_path, alert: "You do not have access to this wishlist."
      return
    end
    @wishlist_items = @wishlist.wishlist_items
  end

  def add_items
    @wishlist = current_user.wishlists.find(params[:id])
    if @wishlist.update(wishlist_params)
      redirect_to @wishlist, notice: "Items added!"
    else
      render :show
    end
  end

  def destroy
    @wishlist = current_user.wishlists.find(params[:id])
    @wishlist.destroy
    redirect_to profile_path, notice: "Wishlist deleted."
  end

  def friends
    @wishlists = current_user.wishlists_shared_with_me
  end

  private

  def require_owner
    @wishlist = current_user.wishlists.find_by(id: params[:id])
    unless @wishlist
      redirect_to profile_path, alert: "You do not have permission to modify this wishlist."
    end
  end

  def wishlist_params
    params.require(:wishlist).permit(
      :title, :description,
      wishlist_items_attributes: [:id, :name, :url, :notes, :image, :_destroy]
    )
  end
end