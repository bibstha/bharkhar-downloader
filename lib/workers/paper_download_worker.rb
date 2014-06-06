require 'date'
require_relative '../paper_downloader'
require_relative '../config'

module Bharkhar
  class PaperDownloadWorker
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    recurrence { daily.hour_of_day(7) }

    def perform(name = nil, date = Date.today)
      if not name
        queue_workers_for_each_paper
      else
        handle_paper(name, date)
      end
    end

    def queue_workers_for_each_paper
      config.fetch("papers").each do |name, paper_settings|
        if paper_settings.fetch("enabled")
          PaperDownloadWorker.perform_async name
        end
      end
    end

    def handle_paper(name, date)
      PaperDownloader.new(name, date).download
    end

    def config
      @config ||= Config.load
    end

  end
end