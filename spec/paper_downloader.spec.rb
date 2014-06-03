require_relative 'spec_helper'
require 'paper_downloader'

include Bharkhar
describe PaperDownloader do

  it '#download should initiate download' do
    VCR.use_cassette "myrepublica_2014_5_27" do
      PaperDownloader.new('com_myrepublica', {"class_name" => "ComMyrepublica"}, Date.civil(2014,5,27))
      .download
    end
  end

end