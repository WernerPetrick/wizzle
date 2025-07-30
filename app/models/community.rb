class Community < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_one_attached :avatar
  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user
  has_many :community_invitations, dependent: :destroy

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

end
