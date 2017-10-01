require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# require 'rubygems'
require 'vcr'
require 'mocha/mini_test'
require 'simplecov'
require 'simplecov-shield'
require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/poltergeist'
require 'capybara-screenshot/minitest'

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

  SimpleCov.start 'rails'
  # SimpleCov.formatter = SimpleCov::Formatter::ShieldFormatter unless ENV['CIRCLE_CI']

  def sample_cover(filename: "cover_image.jpg")
    File.new("test/fixtures/files/#{filename}")
  end
end

class JamChop::IntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::Screenshot::MiniTestPlugin
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions
  Capybara.default_driver = :poltergeist
  Capybara.server_port = 55153
  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  VCR.configure do |config|
    config.cassette_library_dir = "test/cassettes"
    config.hook_into :webmock
    config.ignore_hosts 'img.shields.io'
    config.ignore_localhost = true
  end
end