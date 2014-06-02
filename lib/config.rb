require 'yaml'

module Bharkhar
  class Config
    class << self
      def load
        @config ||= YAML.load_file("config/Bharkhar.yml").fetch(env)
      end

      def env
        ENV.fetch("RACK_ENV", "development")
      end
    end
  end
end