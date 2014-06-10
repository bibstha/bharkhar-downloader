require_relative '../spec_helper'
require 'bharkhar/crawler/com_ekantipur'

module Bharkhar::Crawler
  describe ComEkantipur do

    it '#page_urls return the list of image urls for today' do
      VCR.use_cassette('ekantipur_2014_06_06') do
        crawler = ComEkantipur.new
        page_urls = crawler.page_urls
        page_urls.must_include "http://epaper.ekantipur.com/epaperimage/kantipur/001.jpg"
        page_urls.must_include "http://epaper.ekantipur.com/epaperimage/kantipur/028.jpg"
        page_urls.length.must_equal 28
      end
    end

  end
end