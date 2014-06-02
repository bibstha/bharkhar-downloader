require 'sinatra'
require 'slim'
require_relative '../config'

set :environment, :production

get '/' do
  @title = 'Bharkhar matrai pakeko ekdam taja'
  @date_file_map = date_file_map
  slim :index, layout: :layout
end

def date_file_map
  papers.inject({}) do |accum, paper|
    paper_name, paper_details = paper
    begin
      pwd = Dir.pwd
      Dir.chdir(File.join(pdf_write_path, paper_name))

      last_date = Dir.glob("*.pdf").map do |pdf|
        Date.parse(pdf[0..-5])
      end.sort.last # latest pdf

    rescue StandardError => e
      # puts e
    ensure
      Dir.chdir(pwd)
    end
    
    if last_date
      accum[last_date] ||= []
      accum[last_date] << paper_name
    end
    
    accum
  end
end

def pdf_write_path
  @pdf_write_path ||= File.expand_path(config.fetch("pdf_write_dir"))
end

def papers
  @papers ||= config.fetch("papers").inject({}) do |accum, paper|
    paper_name, paper_details = paper
    accum[paper_name] = paper_details if paper_details.fetch("enabled")
    accum
  end
end

def config
  @config ||= Bharkhar::Config.load
end
