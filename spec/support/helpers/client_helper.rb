# frozen_string_literal: true

require 'logger'

def configure_client(base_url: nil, api_key: nil, username: nil, password: nil, cancel_url: nil, cancel_wsdl: nil)
  DhlUk::Client.configure do |config|
    config.base_url = base_url || ENV.fetch('DHL_UK_BASE_URL')
    config.api_key = api_key || ENV.fetch('DHL_UK_API_KEY')
    config.username = username || ENV.fetch('DHL_UK_USERNAME')
    config.password = password || ENV.fetch('DHL_UK_PASSWORD')
    config.cancel_url = cancel_url || ENV.fetch('DHL_UK_CANCEL_URL')
    config.cancel_wsdl = cancel_wsdl || ENV.fetch('DHL_UK_CANCEL_WSDL')

    logger = Logger.new(STDERR)
    logger.level = :debug
    config.logger = logger
  end
end
