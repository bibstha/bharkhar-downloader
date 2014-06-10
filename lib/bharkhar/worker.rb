module Bharkhar
  module Worker

    def self.included(base)

      base.class_eval do
        include Sidekiq::Worker
        include Sidetiq::Schedulable

        raise "Implement #{self.name}::set_recurrence" unless respond_to? :set_recurrence

        recurrence do |schedule|
          base.set_recurrence(schedule)
        end
      end
    end
    
    # A worker needs to call recurrence method to set rule

    def perform(last, current, date = Date.today.to_s)
      @date = Date.parse(date)
      download
    end

    def download
      Bharkhar::PdfPackager.new(page_urls, "#{paper_name}/#{@date.to_s}.pdf").package
    end

    def page_urls
      raise 'Worker should implement #page_urls'
    end

    private

    def paper_name
      send(:class).name.split("::").last.underscore
    end
    
  end
end