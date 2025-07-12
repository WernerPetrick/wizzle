require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Birthday Reminder',
  cron: '0 6 * * *', # every day at 6am
  class: 'BirthdayReminderJob'
)