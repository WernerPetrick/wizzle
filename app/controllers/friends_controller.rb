class FriendsController < ApplicationController
  before_action :require_login

  def index
    @friends = current_user.friendships.where(status: "accepted").map(&:friend)
    @pending_invitations = current_user.friendships.where(status: "pending")
    @incoming_invitations = Friendship.where(friend: current_user, status: "pending")
  end

  def create
    friend = User.find_by(email: params[:email])
    if friend && friend != current_user
      friendship = current_user.friendships.create(friend: friend, status: "pending")
      if friend.notify_friend_invite?
        FriendInviteMailer.invite(friendship).deliver_now
      end
      redirect_to friends_path, notice: "Invitation sent to #{friend.email}."
    elsif params[:email].present? && params[:email] != current_user.email
      # Invite non-user
      token = SecureRandom.hex(16)
      Invitation.create(email: params[:email], inviter_id: current_user.id, token: token, accepted: false)
      FriendInviteMailer.invite_non_user(params[:email], current_user, token).deliver_now
      redirect_to friends_path, notice: "Invitation sent to #{params[:email]}."
    else
      redirect_to friends_path, alert: "User not found or invalid."
    end
  end

  def accept
    friendship = Friendship.find(params[:id])
    if friendship.friend == current_user && friendship.status == "pending"
      friendship.update(status: "accepted")
      # Create reciprocal friendship if not already present
      unless Friendship.exists?(user: current_user, friend: friendship.user)
        Friendship.create(user: current_user, friend: friendship.user, status: "accepted")
      end
      redirect_to friends_path, notice: "Friendship accepted!"
    else
      redirect_to friends_path, alert: "Invalid invitation."
    end
  end

  def decline
    friendship = Friendship.find(params[:id])
    if friendship.friend == current_user && friendship.status == "pending"
      friendship.destroy
      redirect_to friends_path, notice: "Invitation declined."
    else
      redirect_to friends_path, alert: "Invalid invitation."
    end
  end
end