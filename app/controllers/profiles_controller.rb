class ProfilesController < ApplicationController
  def show
    @user = current_user
    @wishlists = current_user.wishlists.where(private: [false, nil])
    @friends = current_user.friends 
  end

  def update
    @user = current_user
    if @user.update(params.require(:user).permit(:birthday, :notify_friend_invite, :notify_wishlist_question, :notify_question_reply))
      redirect_to profile_path, notice: "Settings updated!"
    else
      render :show
    end
  end
end
