class UsersController < Clearance::UsersController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  def create
    super do |user|
      Rails.logger.info "User created: #{user.email}"
      if user.persisted?
        UserMailer.welcome_email(user).deliver_now
      end
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
end