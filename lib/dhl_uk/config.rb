# frozen_string_literal: true

module DhlUk
  class Config
    attr_accessor :base_url, :api_key, :username, :password, :logger, :cancel_url, :cancel_wsdl
  end
end
