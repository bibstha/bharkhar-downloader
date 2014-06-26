require 'tmpdir'
require 'mini_magick'

module Bharkhar
  class PdfPackager
    
    def initialize(page_urls, pdf_out_path)
      @page_urls = page_urls
      @pdf_out_path = pdf_out_path
    end

    def package
      download.map { |page_path| File.expand_path(page_path, tmp_dir) }.map do |path|
        IO.popen(["file", "--brief", "--mime-type", path], in: :close, err: :close) do |mime|
          if mime.read.chomp.include? "image"
            pdf_path = "#{path[0..-4]}pdf"
            image = MiniMagick::Image.open(path)
            image.format "pdf"
            image.write(pdf_path)
            pdf_path
          else
            path
          end
        end
        
      end.tap do |page_paths|
        cmd = "gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=%s -dBATCH %s"
        puts "exec: #{cmd % [pdf_write_path, page_paths.join(" ")]}"
        IO.popen(cmd % [pdf_write_path, page_paths.join(" ")], in: :close, err: :close) { |x| puts x.read.chomp }
        
        puts "Creating thumbnail at #{thumbnail_write_path}"
        image = MiniMagick::Image.open(page_paths.first)
        image.flatten
        image.thumbnail "170x262"
        image.format "png"
        image.write(thumbnail_write_path)
      end
    ensure
      cleanup
    end

  private

    def download
      @page_urls.map do |page_url|
        Log.debug "Downloading #{page_url}"
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
      @config ||= Bharkhar.config
    end
  end
end