class User < ApplicationRecord
  include Clearance::User
  has_many :wishlists, dependent: :destroy
  has_many :shared_wishlists, foreign_key: :user_id, dependent: :destroy
  has_many :wishlists_shared_with_me, through: :shared_wishlists, source: :wishlist
  has_many :friendships
  has_many :friends, through: :friendships, class_name: "User"
  has_many :gift_histories_given, class_name: "GiftHistory", foreign_key: "giver_id"
  has_many :gift_histories_received, class_name: "GiftHistory", foreign_key: "recipient_id"
end