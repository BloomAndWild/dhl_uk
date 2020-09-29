# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
require 'vcr'

require 'dhl_uk'

Dotenv.load

require_relative 'support/helpers/client_helper'

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  c.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = { match_requests_on: %i[host path] }

  # Filter sensitive test credentials from VCR interaction.
  c.filter_sensitive_data('<API_KEY>') { ENV['DHL_UK_API_KEY'] }
  c.filter_sensitive_data('<USERNAME>') { Faraday::Utils.escape(ENV['DHL_UK_USERNAME']).sub('%40', '@') }
  c.filter_sensitive_data('<UNENCODED_USERNAME>') { ENV['DHL_UK_USERNAME'] }
  c.filter_sensitive_data('<PASSWORD>') { ENV['DHL_UK_PASSWORD'] }
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'pry'
