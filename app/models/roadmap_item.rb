class RoadmapItem < ApplicationRecord
  enum :status, { now: "now", next: "next", ideas: "ideas", shipped: "shipped" }

  default_scope { order(position: :asc) }
end