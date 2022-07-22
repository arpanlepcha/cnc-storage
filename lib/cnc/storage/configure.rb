# frozen_string_literal: true

module Cnc
  module Storage
    class Configuration
      attr_accessor(
        :access_key_id,
        :secret_access_key,
        :region,
        :bucket,
        :endpoint,
        :logger,
        :cdn_url
      )

      def initialize
        @debugging = false
        @logger = defined?(Rails) ? Rails.logger : Logger.new($stdout)
      end

      def self.default
        @@default ||= Configuration.new
      end
    end
  end
end
