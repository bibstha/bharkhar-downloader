require 'typhoeus'
require 'nokogiri'

module Bharkhar
  module Crawler
    class ComEkantipur
      attr_reader :date

      def base_url
        "http://epaper.ekantipur.com/kantipur/"
      end

      def self.set_recurrence schedule
        # 5am utc
        schedule.daily.hour_of_day(1)
      end

      def initialize(date = Date.today)
        # stupid paper only shows paper for that day
        @date = Date.today 
      end

      def page_urls
        frontpage.css("pageFlipper page").map do |page_rel_url|
          "#{base_url}%s/largest3/%s" % [date.strftime('%e%-m%Y'), page_rel_url.content]
        end
      end

      private

      def frontpage_url
        "#{base_url}%s/pages.xml" % date.strftime('%e%-m%Y')
      end

      def frontpage
        @frontpage ||= Nokogiri::XML(Typhoeus.get(frontpage_url).body)
      end

    end
  end
end