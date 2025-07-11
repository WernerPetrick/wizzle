class FriendInviteMailer < ApplicationMailer
  def invite(friendship)
    @inviter = friendship.user
    @friend = friendship.friend
    mail(
      to: @friend.email,
      subject: "#{@inviter.name || @inviter.email} invited you to be friends on Wizzle!"
    )
  end

  def invite_non_user(email, inviter, token)
    @inviter = inviter
    @signup_url = new_user_url(invite_token: token)
    mail(
      to: email,
      subject: "#{@inviter.name || @inviter.email} invited you to join Wizzle!"
    )
  end
end