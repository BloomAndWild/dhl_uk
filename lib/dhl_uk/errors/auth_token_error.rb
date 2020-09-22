# frozen_string_literal: true

module DhlUk
  module Errors
    class AuthTokenError < StandardError
      attr_reader :response, :status

      def initialize(response)
        @response = response
        @status = response.status

        super(status)
      end

      def body
        return @body if instance_variable_defined?(:@body)

        @body = begin
                  JSON.parse(response.body, symbolize_names: true)
                rescue JSON::ParserError
                  response.body
                end
      end
    end
  end
end
