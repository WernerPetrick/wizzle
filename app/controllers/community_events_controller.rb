class CommunityEventsController < ApplicationController
  before_action :require_login
  before_action :set_community
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_admin_access

  def new
    @event = @community.community_events.build
    @available_wishlists = @community.members.joins(:wishlists).includes(:wishlists)
  end

  def create
    @event = @community.community_events.build(event_params)
    @event.created_by = current_user
    @event.event_type = 'custom'

    if @event.save
      # Link wishlists if provided
      if params[:wishlist_ids].present?
        @event.wishlists = Wishlist.where(id: params[:wishlist_ids])
      end
      
      respond_to do |format|
        format.html { 
          flash[:notice] = "Event created successfully!"
          redirect_to @community 
        }
        format.turbo_stream # This will render create.turbo_stream.erb
      end
    else
      @available_wishlists = @community.members.joins(:wishlists).includes(:wishlists)
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace("event_form", partial: "form", locals: { event: @event })
        }
      end
    end
  end

  def show
    unless @community.member?(current_user)
      flash[:alert] = "You must be a community member to view this event."
      redirect_to @community
    end
  end

  def edit
    @available_wishlists = @community.members.joins(:wishlists).includes(:wishlists)
  end

  def update
    if update_event
      flash[:notice] = "Event updated!"
      redirect_to @community
    else
      load_available_wishlists
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event deleted."
    redirect_to @community
  end

  private

  def update_event
    return false unless @event.update(event_params)
    update_wishlist_associations
    true
  end


  def update_wishlist_associations
    if params[:wishlist_ids].present?
      @event.wishlists = Wishlist.where(id: params[:wishlist_ids])
    else
      @event.wishlists.clear
    end
  end

  def load_available_wishlists
    @available_wishlists = @community.members.joins(:wishlists).includes(:wishlists)
  end

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_event
    @event = @community.community_events.find(params[:id])
  end

  def check_admin_access
    unless @community.creator == current_user || @community.community_memberships.find_by(user: current_user)&.role == "admin"
      flash[:alert] = "You must be an admin to manage events."
      redirect_to @community
    end
  end

  def event_params
    params.require(:community_event).permit(:title, :description, :event_date)
  end
end