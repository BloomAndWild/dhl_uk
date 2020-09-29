# frozen_string_literal: true

module DhlUk
  module Operations
    class CreateShipment
      RESOURCE_PATH = '/gateway/DomesticConsignment/1.0/DomesticConsignment'

      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
      }.freeze

      def initialize payload:
        @payload = payload
      end

      def execute
        http_client = Faraday.new

        response = http_client.run_request(http_method, endpoint, json_payload, headers)

        return JSON.parse(response.body, symbolize_names: true) if response.success?

        raise DhlUk::Errors::ResponseError.new(payload: payload, response: response)
      end

      private

      attr_reader :payload

      def http_method
        :post
      end

      def endpoint
        config.base_url + RESOURCE_PATH
      end

      def json_payload
        JSON.generate(payload)
      end

      def headers
        DEFAULT_HEADERS.merge('x-api-key' => config.api_key)
      end

      def config
        Client.config
      end
    end
  end
end
