class CommunityInvitationsController < ApplicationController
  before_action :require_login
  before_action :set_community, only: [:new, :create]
  before_action :set_invitation, only: [:accept, :decline]
  before_action :check_membership, only: [:new, :create]

  def new
    @invitation = @community.community_invitations.build
    @friends = current_user.friends.where.not(id: @community.members.ids)
                          .where.not(id: @community.community_invitations.pending.pluck(:invitee_id))
  end

  def create
    @invitation = @community.community_invitations.build(invitation_params)
    @invitation.inviter = current_user
    @invitation.status = 'pending'

    if @community.community_invitations.pending.exists?(invitee_id: @invitation.invitee_id)
      flash[:alert] = "This user already has a pending invitation."
      redirect_to @community and return
    end

    if @invitation.save
      flash[:notice] = "Invitation sent successfully!"
      redirect_to @community
    else
      @friends = current_user.friends.where.not(id: @community.members.ids)
                            .where.not(id: @community.community_invitations.pending.pluck(:invitee_id))
      render :new
    end
  end

  def accept
    if @invitation.invitee == current_user
      @invitation.accept!
      flash[:notice] = "You've joined #{@invitation.community.name}!"
      redirect_to @invitation.community
    else
      flash[:alert] = "You can't accept this invitation."
      redirect_to communities_path
    end
  end

  def decline
    if @invitation.invitee == current_user
      @invitation.decline!
      flash[:notice] = "Invitation declined."
      redirect_to communities_path
    else
      flash[:alert] = "You can't decline this invitation."
      redirect_to communities_path
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_invitation
    @invitation = CommunityInvitation.find(params[:id])
  end

  def check_membership
    unless @community.can_invite?(current_user)
      flash[:alert] = "You must be a member to invite others to this community."
      redirect_to @community
    end
  end

  def invitation_params
    params.require(:community_invitation).permit(:invitee_id)
  end
end