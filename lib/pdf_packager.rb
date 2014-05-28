require 'tmpdir'
require 'RMagick'

require_relative 'config'

module Bharkhar
  class PdfPackager
    
    def initialize(page_urls, pdf_out_path)
      @page_urls = page_urls
      @pdf_out_path = pdf_out_path
    end

    def package
      begin
        download.map { |page_path| File.expand_path(page_path, tmp_dir) }
        .tap do |page_paths|
          image_list = Magick::ImageList.new(*page_paths)
          image_list.write(pdf_write_path)

          front_page = Magick::Image.read(page_paths.first).first
          front_page.thumbnail(170, 262).write(thumbnail_write_path)
        end
      ensure
        cleanup
      end
    end

  private

    def download
      @page_urls.map do |page_url|
        response = Typhoeus.get(page_url)
        basename = File.basename(page_url)
        tmp_page_path = File.expand_path(basename, tmp_dir)
        File.write(tmp_page_path, response.body)
        basename
      end
    end

    def tmp_dir
      @tmp_dir ||= Dir.mktmpdir(nil, File.expand_path(config.fetch("tmp_dir")))
    end

    def cleanup
      FileUtils.remove_entry(tmp_dir)
    end

    def pdf_write_path
      @pdf_write_path ||= File.expand_path(@pdf_out_path, config.fetch("pdf_write_dir"))
      FileUtils.makedirs(File.dirname(@pdf_write_path)) unless Dir.exists?(File.dirname(@pdf_write_path))
      @pdf_write_path
    end

    def thumbnail_write_path
      return @thumbnail_write_path if @thumbnail_write_path

      # _out_path are relative to config defined path
      thumbnail_out_path = @pdf_out_path[0..-4] + "png"
      @thumbnail_write_path = File.expand_path(thumbnail_out_path, config.fetch("thumbnail_write_dir"))
      FileUtils.makedirs(File.dirname(@thumbnail_write_path)) unless Dir.exists?(File.dirname(@thumbnail_write_path))
      @thumbnail_write_path
    end

    def config
      @config ||= Config.load
    end
  end
end