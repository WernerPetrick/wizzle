class UserMailer < ApplicationMailer
  default from: "welcome@wizzle.gifts"
  
  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to Wizzle!"
    )
  end
end