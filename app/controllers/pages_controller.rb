class PagesController < ApplicationController
  def index
    
  end

  def how_it_works
    
  end
  
  def about 
    
  end
  
  def roadmap
    @roadmap_items = RoadmapItem.order(:position)
  end
end
