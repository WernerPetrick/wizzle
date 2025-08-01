class Community < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_one_attached :avatar
  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user
  has_many :community_invitations, dependent: :destroy
  has_many :community_events, dependent: :destroy
  has_many :secret_santas, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }

  def can_invite?(user)
    members.include?(user)
  end

  def already_invited?(user)
    community_invitations.where(invitee: user, status: 'pending').exists?
  end

  def member?(user)
    members.include?(user)
  end

  def can_manage_members?(user)
    creator == user || community_memberships.find_by(user: user)&.role == "admin"
  end

  def can_remove_member?(current_user, member)
    (creator == current_user || 
     community_memberships.find_by(user: current_user)&.role == "admin") &&
    member != creator && 
    member != current_user
  end

  def can_manage_admin_roles?(current_user, member)
    creator == current_user && member != creator
  end

  def upcoming_events
    community_events.upcoming.order(:event_date).limit(5)
  end

  def upcoming_birthdays
    members.where.not(birthday: nil)
          .where('EXTRACT(month FROM birthday) >= ? AND EXTRACT(day FROM birthday) >= ? OR EXTRACT(month FROM birthday) > ?', 
                  Date.current.month, Date.current.day, Date.current.month)
          .order(Arel.sql('EXTRACT(month FROM birthday), EXTRACT(day FROM birthday)'))
  end

  def upcoming_secret_santas
    secret_santas.where(status: 'active')
             .where('event_date >= ?', Date.current)
             .order(:event_date)
             .limit(5)
  end
end
