require 'typhoeus'
require 'nokogiri'

module Bharkhar
  module Crawler
    class ComEkantipur

      URL = "http://epaper.ekantipur.com/"

      def self.set_recurrence schedule
        # 5am utc
        schedule.daily.hour_of_day(5)
      end

      def initialize(date = Date.today)
        # stupid paper only shows paper for that day
        @date = Date.today 
      end

      def page_urls
        frontpage.css(".col-md-3 .rows a img").map do |thumb_url|
          thumb_url['src'].gsub(/thumb\//, '')
        end
      end

      private

      def frontpage_url
        "http://epaper.ekantipur.com/epaper/kdaily/page/1"
      end

      def frontpage
        @frontpage ||= Nokogiri::HTML(Typhoeus.get(frontpage_url).body)
      end

    end
  end
end