module CommunitiesHelper
  def member_display_name(user)
    user.name.presence || user.email.split('@').first.humanize
  end

  def can_manage_admin_roles?(community, member)
    return false unless current_user
    community.creator == current_user && member != community.creator
  end

  def can_remove_member?(community, member)
    return false unless current_user
    
    (community.creator == current_user || 
     community.community_memberships.find_by(user: current_user)&.role == "admin") &&
    member != community.creator && 
    member != current_user
  end
end