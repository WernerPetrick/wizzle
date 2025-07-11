class GiftHistory < ApplicationRecord
  belongs_to :giver, class_name: "User"
  belongs_to :recipient, class_name: "User"
  belongs_to :wishlist_item
end