require 'typhoeus'
require 'nokogiri'
require 'uri'
require 'json'
require 'date'

module Bharkhar
  module Crawler
    class ComMyrepublica
      
      URL = "http://e.myrepublica.com/"

      attr_reader :date

      def self.set_recurrence schedule
        # 5am utc
        schedule.daily.hour_of_day(3)
      end

      def initialize(date = Date.today)
        @date = date
      end

      def page_urls
        parsed_urls = Typhoeus.get(paper_url).body.match(/enlargedImages = (\[.+?\])/m)[1].to_s
        urls = JSON.parse(parsed_urls)
        urls.map do |relative_url|
        
          relative_url = (relative_url[-1] == "|") ? relative_url[0..-2] : relative_url
          URI(URL).merge!(relative_url).to_s

        end
      end

    private 

      def paper_url
        raise DateNotFound, "Date #{@date} not found" unless all_papers[@date]
        all_papers[@date]
      end

      def all_papers
        frontpage = Nokogiri::HTML(Typhoeus.get(URL).body)
        frontpage.css('.fb_book_list_table a').inject({}) do |url_map, paper|
          
          date = Date.parse paper['title'].match(/[0-9]+.*/).to_s # Republica 26 May 2014
          url  = URI(URL).merge!(paper['href']).to_s

          url_map[date] = url
          url_map
        end
      end

      class DateNotFound < StandardError; end

    end
  end
end