class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :role, presence: true, inclusion: { in: %w[admin member] }
  validates :user_id, uniqueness: { scope: :community_id }
end