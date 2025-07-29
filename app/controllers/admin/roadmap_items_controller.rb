module Admin
  class RoadmapItemsController < ApplicationController
    before_action :set_roadmap_item, only: %i[edit update destroy]

    def index
      @roadmap_items = RoadmapItem.all
    end

    def new
      @roadmap_item = RoadmapItem.new
    end

    def create
      @roadmap_item = RoadmapItem.new(roadmap_item_params)
      if @roadmap_item.save
        redirect_to admin_roadmap_items_path, notice: "Roadmap item created!"
      else
        render :new
      end
    end

    def edit; end

    def update
      if @roadmap_item.update(roadmap_item_params)
        redirect_to admin_roadmap_items_path, notice: "Roadmap item updated!"
      else
        render :edit
      end
    end

    def destroy
      @roadmap_item.destroy
      redirect_to admin_roadmap_items_path, notice: "Roadmap item deleted!"
    end

    def sort
      ids = params[:roadmap_item]
      status = params[:status]

      RoadmapItem.transaction do
        ids.each_with_index do |id, index|
          item = RoadmapItem.find(id)
          attrs = { position: index + 1 }
          attrs[:status] = status if item.status != status
          item.update!(attrs)
        end
      end

      head :ok
    end

    private

    def set_roadmap_item
      @roadmap_item = RoadmapItem.find(params[:id])
    end

    def roadmap_item_params
      params.require(:roadmap_item).permit(:title, :description, :status, :position)
    end
  end
end
