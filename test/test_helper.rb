require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# require 'rubygems'
require 'vcr'
require 'mocha/mini_test'
require 'simplecov'
require 'simplecov-shield'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  VCR.configure do |config|
    config.cassette_library_dir = "test/cassettes"
    config.hook_into :webmock
    config.ignore_hosts 'img.shields.io'
  end

  if ENV['CIRCLE_ARTIFACTS']
    dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
    SimpleCov.coverage_dir(dir)
  end

  SimpleCov.start
  SimpleCov.formatter = SimpleCov::Formatter::ShieldFormatter
end
