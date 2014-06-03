require 'rake/testtask'
require_relative 'lib/config'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.pattern = 'spec/**/*.spec.rb'
end

desc "Download all of the latest papers"
task :download_latest do |t|
  require 'date'
  require_relative 'lib/paper_downloader'
  
  config = Bharkhar::Config.load
  config.fetch("papers").each do |name, paper_settings|
    puts "#{name} enabled -> #{paper_settings.fetch("enabled")}"
    if paper_settings.fetch("enabled")
      puts "Downloading #{name} for #{Date.today.to_s}"
      Bharkhar::PaperDownloader.new(name, config.fetch("papers").fetch(name)).download
    end
  
  end
end