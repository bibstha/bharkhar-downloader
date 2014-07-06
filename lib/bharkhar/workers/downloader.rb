require_relative '../../bharkhar'
require_relative '../../../config/redis'
require_relative '../../../config/sidekiq'
require 'bharkhar/worker'

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