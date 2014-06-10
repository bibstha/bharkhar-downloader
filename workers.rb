require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/exception_handler'
require 'sidetiq'
require './lib/bharkhar'

# Calm down
Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'Bharkhar', :size => 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'Bharkhar', :size => 5 }
end

Sidekiq::RetrySet.new.clear
Sidekiq::Queue.new.clear
Sidekiq::ScheduledSet.new.clear

Sidetiq.configure do |config|
  config.utc = true
end

Bharkhar.config.fetch("papers").each do |name, settings|
  if settings.fetch("enabled")
    require "bharkhar/crawler/#{name}"
    class_name = "Bharkhar::Crawler::#{name.camelize}"
    puts "Hard working #{class_name}"
    Kernel.const_get(class_name).class_eval do
      include Bharkhar::Worker
    end
  end
  
end