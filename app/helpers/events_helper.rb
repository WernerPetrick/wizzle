module EventsHelper
  def event_card_styles(event)
    if event.is_a?(User)
      "background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 0.7rem; padding: 1rem;"
    else
      "background: #e3f2fd; border: 1px solid #bbdefb; border-radius: 0.7rem; padding: 1rem;"
    end
  end

  def event_text_color(event)
    event.is_a?(User) ? "#856404" : "#1565c0"
  end

  def event_bg_color(event)
    event.is_a?(User) ? "#856404" : "#1565c0"
  end

  def event_wishlists_path(event, community)
    if event.is_a?(User)
      user_path(event)
    else
      community_community_event_path(community, event)
    end
  end
end