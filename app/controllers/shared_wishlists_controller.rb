class SharedWishlistsController < ApplicationController
  before_action :require_login
  before_action :set_wishlist

  def create
    user = User.find_by(email: params[:email])
    
    if user.nil?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("sharing_form", 
            partial: "wishlists/sharing_form_with_error", 
            locals: { wishlist: @wishlist, error: "User with email #{params[:email]} not found." })
        end
        format.html { redirect_to @wishlist, alert: "User with email #{params[:email]} not found." }
      end
      return
    end

    if @wishlist.shared_users.include?(user)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("sharing_form", 
            partial: "wishlists/sharing_form_with_error", 
            locals: { wishlist: @wishlist, error: "Wishlist is already shared with #{user.email}." })
        end
        format.html { redirect_to @wishlist, alert: "Wishlist is already shared with #{user.email}." }
      end
      return
    end

    @wishlist.shared_users << user

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("sharing_form", 
            partial: "wishlists/sharing_form", locals: { wishlist: @wishlist }),
          turbo_stream.replace("shared_users_list", 
            partial: "shared_users", locals: { wishlist: @wishlist })
        ]
      end
      format.html { redirect_to @wishlist, notice: "Wishlist shared with #{user.email}!" }
    end
  end

  def destroy
    user = User.find(params[:id])
    @wishlist.shared_users.delete(user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("shared_user_#{user.id}"),
          turbo_stream.replace("shared_users_list", 
            partial: "shared_users", locals: { wishlist: @wishlist })
        ]
      end
      format.html { redirect_to @wishlist, notice: "Removed #{user.email}'s access to this wishlist." }
    end
  end

  private

  def set_wishlist
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to profile_path, alert: "You do not have permission to modify this wishlist."
  end
end