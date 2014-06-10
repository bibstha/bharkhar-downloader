require_relative '../spec_helper'
require 'bharkhar/crawler/com_myrepublica'

include Bharkhar::Crawler
describe ComMyrepublica do

  it '#current_date returns defautl date' do
    crawler = ComMyrepublica.new()
    crawler.date.year.must_equal Date.today.year
    crawler.date.month.must_equal Date.today.month
    crawler.date.day.must_equal Date.today.day
  end

  it '#date returns passed date' do
    crawler = ComMyrepublica.new(date = Date.today)
    crawler.date.must_equal date
  end

  it '#page_urls return urls of pages for given date' do
    VCR.use_cassette 'myrepublica_2014_5_1' do
      date = Date.civil(2014, 5, 1)
      crawler = ComMyrepublica.new(date = Date.today)
      page_urls = crawler.send(:page_urls)

      page_urls.size.must_equal  16
      page_urls.first.must_equal "http://e.myrepublica.com/images/flippingbook/2014_May_26/republica/rp_zoom_01.jpg"
      page_urls.last.must_equal  "http://e.myrepublica.com/images/flippingbook/2014_May_26/republica/rp_zoom_16.jpg"
    end
  end

  it '#paper_url should return valid url' do
    VCR.use_cassette 'myrepublica_homepage_on_2014_5_26' do
      date      = Date.civil(2014, 5, 26)
      crawler   = ComMyrepublica.new(date)
      paper_url = crawler.send(:paper_url)
      paper_url.must_equal 'http://e.myrepublica.com/component/flippingbook/book/1609-republica-26-mayl-2014/1-republica.html'
    end
  end
end