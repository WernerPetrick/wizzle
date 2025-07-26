# Puma configuration for Railway deployment

max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "production" }

# Uncomment if you want clustered workers (requires PostgreSQL or production-ready DB)
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }
# preload_app!

plugin :tmp_restart
