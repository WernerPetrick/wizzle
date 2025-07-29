class RoadmapItemsController < ApplicationController
   def index
    @roadmap_items = RoadmapItem.all
  end

  def sort
    ids = params[:roadmap_item]
    status = params[:status]
    
    ids.each_with_index do |id, index|
      RoadmapItem.where(id: id, status: status).update_all(position: index + 1)
    end

    head :ok
  end
end
