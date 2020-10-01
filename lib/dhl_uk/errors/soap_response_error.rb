# frozen_string_literal: true

module DhlUk
  module Errors
    class SoapResponseError < Error
      attr_reader :payload

      def initialize(response, payload)
        @payload = payload
  # TODO: parse error messages
        super(response)
      end
    end
  end
end
