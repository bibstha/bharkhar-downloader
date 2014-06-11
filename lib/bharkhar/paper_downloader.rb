require 'date'

module Bharkhar
  class PaperDownloader

    def initialize name, date = Date.today
      @name     = name
      @settings = config.fetch("papers").fetch(name)
      @date     = date
    end

    def download
      page_urls = crawler.page_urls
      PdfPackager.new(page_urls, "#{@name}/#{@date.to_s}.pdf").package
    end

  private

    def crawler
      require_relative "crawler/#{@name}"
      class_name = "Bharkhar::Crawler::#{@name.camelize}"
      Kernel.const_get(class_name).new(@date)
    end

    def config
      Bharkhar.config
    end

  end
end