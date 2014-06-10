require 'typhoeus'
require 'nokogiri'
require_relative 'com_ekantipur'

module Bharkhar
  module Crawler
    class ComEkantipurKpost < ComEkantipur

      def frontpage_url
        "http://epaper.ekantipur.com/epaper/kpost/page/1"
      end

    end
  end
end