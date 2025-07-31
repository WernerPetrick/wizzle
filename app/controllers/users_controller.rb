class UsersController < Clearance::UsersController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  def create
    super do |user|
      if params[:invite_token].present?
        invitation = Invitation.find_by(token: params[:invite_token], accepted: false)
        if invitation && invitation.email == user.email
          invitation.update(accepted: true)
          Friendship.create(user: invitation.inviter, friend: user, status: "accepted")
          Friendship.create(user: user, friend: invitation.inviter, status: "accepted")
        end
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @shared_wishlists = @user.wishlists.where(private: [false, nil])
  end

  def anonymize!
    transaction do
      update!(
        email: "deleted_user_#{id}@example.com",
        encrypted_password: SecureRandom.hex,
        remember_token: SecureRandom.hex,
        birthday: nil,
        notify_friend_invite: false,
        notify_wishlist_question: false,
        notify_question_reply: false
      )
      friendships.destroy_all
      wishlists.update_all(title: "Deleted Wishlist", description: nil)
    end
  end
end