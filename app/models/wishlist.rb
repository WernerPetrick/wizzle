class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_items, dependent: :destroy
  has_many :shared_wishlists, dependent: :destroy
  has_many :shared_users, through: :shared_wishlists, source: :user
  accepts_nested_attributes_for :wishlist_items, allow_destroy: true
end