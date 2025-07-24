class WishlistsController < ApplicationController
  before_action :require_login
  before_action :require_owner, only: [:destroy, :add_items]
  skip_before_action :require_login, only: [:public_show]

  def new
    @wishlist = current_user.wishlists.new
    2.times { @wishlist.wishlist_items.build }
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
    @wishlist = current_user.wishlists.find_by(id: params[:id])

    unless @wishlist
      @wishlist = Wishlist.joins(:shared_wishlists)
        .where(id: params[:id], shared_wishlists: { user_id: current_user.id })
        .first
    end

    unless @wishlist
      wishlist = Wishlist.find_by(id: params[:id], private: [false, nil])
      if wishlist && current_user.friends.include?(wishlist.user)
        @wishlist = wishlist
      end
    end

    if @wishlist.nil?
      redirect_to profile_path, alert: "You do not have access to this wishlist."
      return
    end

    @wishlist_items = @wishlist.wishlist_items

    respond_to do |format|
      format.html
      format.any { head :not_acceptable }
    end
  end

  def public_show
    @wishlist = Wishlist.find_by(public_token: params[:token])
    if @wishlist.nil?
      redirect_to root_path, alert: "Wishlist not found."
    else
      @wishlist_items = @wishlist.wishlist_items
      render :public_show, layout: "public"
    end
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
    @wishlists = Wishlist.where(
      user_id: current_user.friends.pluck(:id),
      private: [false, nil]
    )
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
      :title, :description, :private,
      wishlist_items_attributes: [:id, :name, :url, :notes, :image, :_destroy]
    )
  end
end