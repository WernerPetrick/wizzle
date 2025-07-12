class WishlistReminderMailer < ApplicationMailer
  def birthday_reminder(user, days_until)
    @user = user
    @days_until = days_until
    mail(
      to: @user.email,
      subject: "Your birthday is coming up! Update your wishlist"
    )
  end
end