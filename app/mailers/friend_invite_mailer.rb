class FriendInviteMailer < ApplicationMailer
  def invite(invitation)
    @inviter = invitation.inviter
    @friend_email = invitation.email
    @accept_invitation_url = accept_invitation_url(token: invitation.token)
    @login_url = sign_in_url
    mail(
      to: @friend_email,
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