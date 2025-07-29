module RoadmapItemsHelper
  def status_label(status)
    case status.to_s
    when 'in_progress' then "In Progress"
    when 'up_next'     then "Up Next"
    when 'shipped'     then "Shipped"
    else status.humanize
    end
  end
end
