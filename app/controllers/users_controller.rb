class UsersController < ApplicationController
  before_action :require_login

  def create
    super do |user|
      if params[:invite_token].present?
        invitation = Invitation.find_by(token: params[:invite_token], accepted: false)
        if invitation && invitation.email == user.email
          invitation.update(accepted: true)
          # Create reciprocal friendships
          Friendship.create(user: invitation.inviter, friend: user, status: "accepted")
          Friendship.create(user: user, friend: invitation.inviter, status: "accepted")
        end
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @shared_wishlists = @user.wishlists.joins(:shared_wishlists)
      .where(shared_wishlists: { user_id: current_user.id })
  end
end