require 'date'
require 'typhoeus'
require 'nokogiri'
require 'uri'

module Bharkhar
  module Crawler
    class ComThehimalayantimes

      URL = "http://epaper.thehimalayantimes.com/"

      def initialize(date = Date.today)
        @date = date
      end

      def page_urls
        pages = mainpage.css('#pages span.pagedeselect').map do |span|
          span.content.gsub("Page-", '').to_i
        end
        pages.map do |page_number|
          URI(URL).merge!(imageurl_to_pdf page_number).to_s
        end
      end

      private

      def mainpage_url
        "http://epaper.thehimalayantimes.com/epapermain.aspx?queryed=9&eddate=%s" % @date.strftime("%-m/%-d/%Y")
      end

      def mainpage
        @mainpage ||= Nokogiri::HTML(Typhoeus.get(mainpage_url).body)
      end

      def frontpage_imageurl
        File.write("/tmp/tht.html", mainpage.inner_html)
        @frontpage_imageurl ||= mainpage.at_css('#spanthumbNumber1')['src']
      end

      def imageurl_to_pdf page_number
        frontpage_imageurl.gsub(/(EpaperImages|1ss.jpg)/, "EpaperImages" => "epaperpdf", "1ss.jpg" => "#{page_number}.pdf")
      end

    end
  end
end