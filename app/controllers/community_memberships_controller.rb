class CommunityMembershipsController < ApplicationController
  before_action :set_community

  def destroy
    @community = Community.find(params[:id])
    if @community.creator == current_user
      @community.destroy
      flash[:notice] = "Community deleted."
      redirect_to communities_path
    else
      flash[:alert] = "Only the owner can delete the community."
      redirect_to @community
    end
  end

  def update
    membership = @community.community_memberships.find(params[:id])
    # Only the creator can change roles, and not for themselves
    if @community.creator == current_user && membership.user != current_user
      new_role = params[:role]
      if %w[admin member].include?(new_role)
        membership.update(role: new_role)
        flash[:notice] = "Role updated."
      else
        flash[:alert] = "Invalid role."
      end
    else
      flash[:alert] = "You can't change this member's role."
    end
    redirect_to community_path(@community)
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def can_manage_members?
    @community.creator == current_user || @community.community_memberships.find_by(user: current_user)&.role == "admin"
  end
end