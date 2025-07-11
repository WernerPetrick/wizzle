class WishlistItemNote < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :sender, class_name: "User", optional: true
end
