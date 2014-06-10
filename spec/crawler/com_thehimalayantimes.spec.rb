require_relative '../spec_helper'
require 'bharkhar/crawler/com_thehimalayantimes'

module Bharkhar::Crawler
  describe ComThehimalayantimes do

    let(:date)    { Date.civil(2014, 6, 6) }
    let(:crawler) { ComThehimalayantimes.new(date) }

    it '#mainpage_url returns formatted date' do
      crawler.send(:mainpage_url).must_equal(
        "http://epaper.thehimalayantimes.com/epapermain.aspx?queryed=9&eddate=6/6/2014"
      )
    end

    it '#frontpage_imageurl returns valid url' do
      VCR.use_cassette('tht_2014_6_6') do
        crawler.send(:frontpage_imageurl).must_equal(
          "EpaperImages/662014/662014-md-hr-1ss.jpg"
        )
      end
    end

    it 'imageurl_to_pdf returns pdf url' do
      VCR.use_cassette('tht_2014_6_6') do
        crawler.send(:imageurl_to_pdf, 7).must_equal(
          "epaperpdf/662014/662014-md-hr-7.pdf"
        )
      end
    end

    it 'page_urls return list os pdf urls' do
      VCR.use_cassette('tht_2014_6_6') do
        page_urls = crawler.page_urls

        page_urls.must_include("http://epaper.thehimalayantimes.com/epaperpdf/662014/662014-md-hr-1.pdf")
        page_urls.must_include("http://epaper.thehimalayantimes.com/epaperpdf/662014/662014-md-hr-20.pdf")

        # somehow page 9 is missing, THT sigh.
        page_urls.wont_include("http://epaper.thehimalayantimes.com/epaperpdf/662014/662014-md-hr-9.pdf")
      end
    end
  end
end