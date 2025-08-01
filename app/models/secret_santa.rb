class SecretSanta < ApplicationRecord
  self.table_name = 'secret_santas'
  
  belongs_to :community
  belongs_to :created_by, class_name: 'User'
  has_many :secret_santa_assignments, dependent: :destroy
  has_many :participants, through: :secret_santa_assignments, source: :giver

  validates :title, presence: true
  validates :event_date, presence: true
  validates :status, inclusion: { in: %w[draft active completed cancelled] }

  scope :active, -> { where(status: 'active') }
  scope :upcoming, -> { where('event_date >= ?', Date.current) }

  def draft?
    status == 'draft'
  end

  def active?
    status == 'active'
  end

  def can_edit?
    draft?
  end

  def participant_count
    community.members.count
  end

  def can_generate_assignments?
    draft? && participant_count >= 3
  end
end