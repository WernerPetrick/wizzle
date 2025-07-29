class BlogPost < ApplicationRecord
  attr_accessor :markdown_file
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true
  validates :body, presence: true
end
