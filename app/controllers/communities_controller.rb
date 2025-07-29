class CommunitiesController < ApplicationController
  before_action :require_login
  before_action :set_community, only: [:show, :edit, :update, :members]
  before_action :require_creator, only: [:edit, :update]

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
      # Automatically add creator as admin member
      @community.community_memberships.create!(user: current_user, role: 'admin')
      flash[:notice] = "Community created successfully!"
      redirect_to @community
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      flash[:notice] = "Community updated successfully!"
      redirect_to @community
    else
      render :edit
    end
  end

  def members
    @members = @community.members.includes(:wishlists)
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end

  def require_creator
    unless @community.creator == current_user
      flash[:alert] = "Only the community creator can edit this community."
      redirect_to @community
    end
  end

  def community_params
    params.require(:community).permit(:name, :description)
  end
end