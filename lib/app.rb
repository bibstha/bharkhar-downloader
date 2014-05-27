require 'yaml'

module Bharkhar
  class App
    
    def initialize(date = Date.today)
      @date = date
      papers.each do |paper_name, details|
        if details.fetch("enabled")
          download paper_name, details.fetch("class_name")
        end
      end
    end

    def config
      @config ||= Config.load
    end

    def papers
      config.fetch("papers")
    end

    def download paper_name, class_name
      convert_pdf crawler(paper_name, class_name).page_urls
    end

    def convert_pdf page_urls
    end

    def crawler name, class_name
      require_relative "crawler/#{paper}"
      class_name = "Crawler::#{details.fetch("name")}"
      Kernel.const_get(class_name).new(@date)
    end
  end
end

Bharkhar::App.new