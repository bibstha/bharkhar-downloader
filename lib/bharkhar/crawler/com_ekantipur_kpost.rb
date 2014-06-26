require 'typhoeus'
require 'nokogiri'
require_relative 'com_ekantipur'

module Bharkhar
  module Crawler
    class ComEkantipurKpost < ComEkantipur

      def base_url
        "http://epaper.ekantipur.com/kpost/"
      end

    end
  end
end