# frozen_string_literal: true

module DhlUk
  module Errors
    class ResponseError < Error
      attr_reader :payload

      def initialize(payload:, response:)
        @payload = payload

        super(response)
      end
    end
  end
end
