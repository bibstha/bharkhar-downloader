require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/exception_handler'
require 'sidetiq'

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIG
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIG
end

Sidekiq::RetrySet.new.clear
Sidekiq::Queue.new.clear
Sidekiq::ScheduledSet.new.clear

Sidetiq.configure do |config|
  config.utc = true
end