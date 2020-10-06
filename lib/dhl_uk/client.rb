# frozen_string_literal: true

module DHLUk
  class Client
    class << self
      attr_reader :config

      def configure
        raise ArgumentError, 'block not given' unless block_given?

        @config = Config.new
        yield config
      end
    end
  end
end
