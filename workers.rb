require 'sidekiq'
require 'sidekiq/exception_handler'
require 'sidetiq'

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'Bharkhar', :size => 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'Bharkhar', :size => 5 }
end

Dir.glob(__dir__ + '/lib/workers/**/*.rb', &method(:require))