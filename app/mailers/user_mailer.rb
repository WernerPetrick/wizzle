class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to Wizzle!"
    )
  end
end