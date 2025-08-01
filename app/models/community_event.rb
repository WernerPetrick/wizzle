class CommunityEvent < ApplicationRecord
  belongs_to :community
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :wishlists

  validates :title, presence: true, length: { maximum: 100 }
  validates :event_date, presence: true
  validates :event_type, presence: true, inclusion: { in: %w[birthday custom] }
  validates :description, length: { maximum: 500 }

  scope :upcoming, -> { where('event_date >= ?', Date.current) }
  scope :birthdays, -> { where(event_type: 'birthday') }
  scope :custom, -> { where(event_type: 'custom') }

  def days_until
    (event_date - Date.current).to_i
  end
end