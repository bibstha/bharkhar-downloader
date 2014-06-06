require 'typhoeus'
require 'nokogiri'

module Bharkhar
  module Crawler
    class ComEkantipur

      URL = "http://epaper.ekantipur.com/"

      def initialize(date = Date.today)
        # stupid paper only shows paper for that day
        @date = Date.today 
      end

      def page_urls
        frontpage.css(".col-md-3 .rows a img").map do |thumb_url|
          thumb_url['src'].gsub(/thumb\//, '')
        end
      end

      def frontpage_url
        "http://epaper.ekantipur.com/epaper/kdaily/page/1"
      end

      def frontpage
        @frontpage ||= Nokogiri::HTML(Typhoeus.get(frontpage_url).body)
      end

      private

    end
  end
end