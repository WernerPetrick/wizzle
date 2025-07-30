class CommunitiesController < ApplicationController
  before_action :require_login
  before_action :set_community, only: [:show, :edit, :update, :members]
  before_action :require_creator_or_admin, only: [:edit, :update]

  def index
    @communities = current_user.communities.includes(:creator, :members)
  end

  def show
    @members = @community.members.includes(:wishlists)
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.created_communities.build(community_params)
    
    if @community.save
      @community.community_memberships.create!(user: current_user, role: 'admin')
      flash[:notice] = "Community created successfully!"
      redirect_to @community
    else
      render :new
    end
  end

  def edit
    @community = Community.find(params[:id])
    
    respond_to do |format|
      format.turbo_stream { render partial: "form", locals: { community: @community } }
      format.html { render :edit }
    end
  end

  def update
    @community = Community.find(params[:id])
    remove_avatar = params[:community].delete(:remove_avatar)
    
    if @community.update(community_params)
      @community.avatar.purge if remove_avatar == "1"
      
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @community }
      end
    else
      respond_to do |format|
        format.turbo_stream { render partial: "form", locals: { community: @community } }
        format.html { render :edit }
      end
    end
  end

  def members
    @members = @community.members.includes(:wishlists)
  end

  def remove_avatar
    @community = Community.find(params[:id])
    if @community.creator == current_user || @community.community_memberships.find_by(user: current_user)&.role == "admin"
      @community.avatar.purge
      flash[:notice] = "Profile picture removed."
    else
      flash[:alert] = "You are not authorized to do this."
    end
    redirect_to edit_community_path(@community)
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end

  def require_creator_or_admin
    unless @community.creator == current_user || @community.community_memberships.find_by(user: current_user)&.role == "admin"
      flash[:alert] = "Only the community owner or an admin can do that."
      redirect_to @community
    end
  end

  def community_params
    params.require(:community).permit(:name, :description, :avatar)
  end
end