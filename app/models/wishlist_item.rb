class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  has_many :wishlist_item_notes, dependent: :destroy
end
