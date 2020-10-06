# frozen_string_literal: true

module DHLUk
  module Errors
    class ResponseError < Error
      attr_reader :payload

      def initialize(response, payload)
        @payload = payload

        super(response)
      end
    end
  end
end
