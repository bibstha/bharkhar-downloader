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
    packager.send(:cmd).must_equal( "gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=%s -dBATCH %s" %
      [
        File.expand_path("tmp/pdf_out_test/test_out.pdf"),
        [
          File.expand_path("tmp/file1.png"),
          File.expand_path("tmp/file2.png"),
          File.expand_path("tmp/file3.png")
        ].join(" ")
      ]
    )
  end

  it '#pdf_write_path appends pdf_out_path to pdf_write_dir' do
    packager = PdfPackager.new([], "test_out.pdf")

    expected_file = File.expand_path("tmp/pdf_out_test/test_out.pdf")
    containing_dir = File.dirname(expected_file)

    packager.send(:pdf_write_path).must_equal expected_file
    Dir.exists?(containing_dir).must_equal true

    # cleanup
    FileUtils.remove_entry containing_dir
  end

  it '#thumbnail_write_path returns valid png path' do
    packager = PdfPackager.new([], "test_out.pdf")

    expected_file = File.expand_path("tmp/thumbnail_out_test/test_out.png")
    containing_dir = File.dirname(expected_file)

    packager.send(:thumbnail_write_path).must_equal expected_file
    Dir.exists?(containing_dir).must_equal true

    # cleanup
    FileUtils.remove_entry containing_dir
  end
end