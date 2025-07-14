class Wishlist < ApplicationRecord
  before_create :set_public_token
  belongs_to :user
  has_many :wishlist_items, dependent: :destroy
  has_many :shared_wishlists, dependent: :destroy
  has_many :shared_users, through: :shared_wishlists, source: :user
  accepts_nested_attributes_for :wishlist_items, allow_destroy: true

  private

  def set_public_token
    self.public_token ||= SecureRandom.urlsafe_base64(16)
  end
end