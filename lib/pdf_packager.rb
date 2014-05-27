require 'config'
require 'tmpdir'

module Bharkhar
  class PdfPackager
    
    def initialize(page_urls, pdf_out_path)
      @page_urls = page_urls
      @pdf_out_path = pdf_out_path
    end

    def package
      begin
        exec(cmd)
      ensure
        cleanup
      end
    end

  private

    def cmd
      batch_paths = download.map do |page_path|
        File.expand_path(page_path, tmp_dir)
      end.join(" ")

      "gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=#{@pdf_out_path} -dBATCH #{batch_paths}"
    end

    def download
      page_urls.map do |page_url|
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

    def config
      @config ||= Config.load
    end
  end
end