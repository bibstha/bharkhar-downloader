require_relative 'spec_helper'
require 'pdf_packager'

include Bharkhar
describe PdfPackager do

  it '#cmd should return valid gs command' do
    packager = PdfPackager.new([], "test_out.pdf")
    packager.stubs(:tmp_dir).returns(File.expand_path("tmp"))
    packager.stubs(:download).returns(
      [
        "file1.png", "file2.png", "file3.png"
      ]
    )
    packager.send(:cmd).must_equal( "gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=test_out.pdf -dBATCH " +
      File.expand_path("../tmp/file1.png", File.dirname(__FILE__)) + " " +
      File.expand_path("../tmp/file2.png", File.dirname(__FILE__)) + " " +
      File.expand_path("../tmp/file3.png", File.dirname(__FILE__)) 
    )
  end

end