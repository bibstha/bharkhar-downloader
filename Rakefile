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
      Bharkhar::PaperDownloader.new(name).download
    end
  
  end
end

desc "Download paper for given date, pass PAPER_NAME=[com_ekantipur|com_thehimalayantimes|...]"
task :download_paper do |t|
  paper_name = ENV['PAPER_NAME']
  unless paper_name
    abort "usage: rake #{ARGV[0]} PAPER_NAME=[com_ekantipur|com_thehimalayantimes|...]"
  end

  require_relative 'lib/paper_downloader'
  Bharkhar::PaperDownloader.new(paper_name).download
end
