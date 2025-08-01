class CommunityInvitation < ApplicationRecord
  belongs_to :community
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  validates :status, presence: true, inclusion: { in: %w[pending accepted declined] }
  validate :no_pending_invitation, on: :create

  before_validation :set_default_status, on: :create

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :declined, -> { where(status: 'declined') }

  def accept!
    ActiveRecord::Base.transaction do
      update!(status: 'accepted')
      community.community_memberships.create!(user: invitee, role: 'member')
    end
  end

  def decline!
    update!(status: 'declined')
  end

  def no_pending_invitation
    if CommunityInvitation.where(community_id: community_id, invitee_id: invitee_id, status: 'pending').exists?
      errors.add(:invitee_id, "already has a pending invitation to this community")
    end
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end
end