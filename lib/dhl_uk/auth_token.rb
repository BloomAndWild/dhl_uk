# frozen_string_literal: true

module DhlUk
  class AuthToken
    RESOURCE_PATH = '/gateway/SSOAuthenticationAPI/1.0/ssoAuth/users/authenticate'

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json'
    }.freeze

    def token
      response = Faraday.get(endpoint, payload, headers)
      raise Errors::AuthTokenError, response unless response.success?

      body = JSON.parse(response.body, symbolize_names: true)
      body.dig(0, :authenticationToken)
    end

    private

    def endpoint
      config.base_url + RESOURCE_PATH
    end

    def payload
      {
        username: config.username,
        password: config.password
      }
    end

    def headers
      DEFAULT_HEADERS.merge('x-api-key' => config.api_key)
    end

    def config
      Client.config
    end
  end
end
