class User < ApplicationRecord
  include Clearance::User
  has_many :wishlists, dependent: :destroy
  has_many :shared_wishlists, foreign_key: :user_id, dependent: :destroy
  has_many :wishlists_shared_with_me, through: :shared_wishlists, source: :wishlist
  has_many :friendships
  has_many :friends, through: :friendships, class_name: "User"
  has_many :gift_histories_given, class_name: "GiftHistory", foreign_key: "giver_id"
  has_many :gift_histories_received, class_name: "GiftHistory", foreign_key: "recipient_id"
  has_many :created_communities, class_name: 'Community', foreign_key: 'creator_id'
  has_many :community_memberships, dependent: :destroy
  has_many :communities, through: :community_memberships
  has_many :sent_community_invitations, class_name: 'CommunityInvitation', foreign_key: 'inviter_id', dependent: :destroy
  has_many :received_community_invitations, class_name: 'CommunityInvitation', foreign_key: 'invitee_id', dependent: :destroy

  after_create :send_welcome_email

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?

  def admin?
    admin
  end

  def pending_community_invitations
    received_community_invitations.pending.includes(:community, :inviter)
  end

  private 

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def password_required?
    new_record? || password.present?
  end

end