require 'date'

module Bharkhar
  class PaperDownloader

    def initialize name, date = Date.today
      Log.debug "Downloading #{name} for #{date}"
      @name     = name
      @settings = config.fetch("papers").fetch(name)
      @date     = date
    end

    def download
      page_urls = crawler.page_urls
      Log.debug "Number of pages: #{Array(page_urls).size}"
      if page_urls.empty?
        Log.error "No pages found"
      else
        PdfPackager.new(page_urls, "#{@name}/#{@date.to_s}.pdf").package
      end
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