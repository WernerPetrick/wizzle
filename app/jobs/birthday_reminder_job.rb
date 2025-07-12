class BirthdayReminderJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.today
    User.where.not(birthday: nil).find_each do |user|
      next unless user.notify_wishlist_question?
      birthday_this_year = user.birthday.change(year: today.year)
      days_until = (birthday_this_year - today).to_i
      if days_until == 30 || days_until == 7
        WishlistReminderMailer.birthday_reminder(user, days_until).deliver_later
      end
    end
  end
end