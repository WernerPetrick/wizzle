require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379") }

  schedule = {
    'birthday_reminder' => {
      'cron' => '0 6 * * *', # every day at 6am
      'class' => 'BirthdayReminderJob'
    }
  }

  Sidekiq::Cron::Job.load_from_hash(schedule)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379") }
end
