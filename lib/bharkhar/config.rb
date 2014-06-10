require 'yaml'

module Bharkhar

  class << self

    attr_reader :config
    attr_reader :env

    def config
      @config = YAML.load_file("config/Bharkhar.yml").fetch(env)
    end

    def env
      ENV.fetch("RACK_ENV", "development")
    end
    
  end
end