class SecretSantaAssignment < ApplicationRecord
  belongs_to :secret_santa
  belongs_to :giver, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :giver_id, uniqueness: { scope: :secret_santa_id }
  validates :receiver_id, uniqueness: { scope: :secret_santa_id }
  validate :giver_cannot_be_receiver

  scope :for_giver, ->(user) { where(giver: user) }

  private

  def giver_cannot_be_receiver
    return unless giver_id == receiver_id
    errors.add(:receiver, "cannot be the same as giver")
  end
end