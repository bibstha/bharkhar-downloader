ENV['RACK_ENV'] ||= 'test'
ENV['TZ'] = 'Europe/Berlin'

$LOAD_PATH << __dir__ + '/../lib'
$LOAD_PATH << __dir__

require 'minitest/autorun'
require 'minitest/pride'
require 'minispec-metadata'
require 'mocha/mini_test'

Minitest::Test.make_my_diffs_pretty!

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.hook_into :typhoeus
end