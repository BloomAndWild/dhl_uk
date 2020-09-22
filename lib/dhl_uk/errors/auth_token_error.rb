# frozen_string_literal: true

module DhlUk
  module Errors
    class AuthTokenError < StandardError
      attr_reader :response, :status, :reason

      def initialize(response)
        @response = response
        @status = response.status
        @reason = response.reason_phrase

        super(build_message)
      end

      def body
        return @body if instance_variable_defined?(:@body)

        @body = JSON.parse(response.body, symbolize_names: true)
      rescue JSON::ParserError
        @body = response.body
      end

      private

      def build_message
        "#{status} #{reason}"
      end
    end
  end
end
