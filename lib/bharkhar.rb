lib = File.expand_path(File.join('..'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'bharkhar/helper/string'
require 'bharkhar/config'
require 'log'
require 'bharkhar/pdf_packager'
require 'bharkhar/errors'

module Bharkhar
end