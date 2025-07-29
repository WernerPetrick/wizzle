class Community < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
end
