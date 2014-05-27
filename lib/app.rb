require 'yaml'
require_relative 'pdf_packager'
require_relative 'config'

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
      page_urls = crawler(paper_name, class_name).page_urls
      PdfPackager.new(page_urls, "#{paper_name}/#{@date.to_s}.pdf").package
    end

    def convert_pdf page_urls
    end

    def crawler paper_name, class_name
      require_relative "crawler/#{paper_name}"
      class_name = "Bharkhar::Crawler::#{class_name}"
      Kernel.const_get(class_name).new(@date)
    end
  end
end

Bharkhar::App.new