class PagesController < ApplicationController
  def index
  end

  def how_it_works
  end
  
  def about 
  end

  def roadmap
  end
  
  def roadmap
    @roadmap_items = RoadmapItem.order(:position)
  end

  def feature_requests

  end

  def submit_feature_request
    email = params[:email]
    idea  = params[:idea]

    if params[:email].blank? || params[:idea].blank?
      flash[:alert] = "Both email and feature idea are required."
      redirect_to feature_requests_path and return
    end

    FeatureRequestMailer.with(email: email, idea: idea).feature_request.deliver_now

    flash[:notice] = "Thank you for your idea! We'll review it soon."
    redirect_to feature_requests_path
  end
end
