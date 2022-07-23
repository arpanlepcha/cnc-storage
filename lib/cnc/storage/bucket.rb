# frozen_string_literal: true

module Cnc
  module Storage
    class Bucket
      def initialize(config = Configuration.default)
        @config = config
      end

      def self.default
        @default ||= Bucket.new
      end

      def upload_file(params = {}, options = {})
        params = default_arguments.merge(params)
        async = options.delete(:async)

        if async
          Async::Thread.call(client, params, options)
        else
          client.put_object(params, options)
        end
      end

      private

      def default_arguments
        {
          bucket: @config.bucket,
          acl: 'public-read',
          cache_control: 'public, max-age=31536000, immutable',
          expires: Time.now + (365 * 86_400)
        }
      end

      # using clients directly because bucket object creates a bucket, which we don't want
      def client
        @client ||= Aws::S3::Client.new(
          region: @config.region,
          access_key_id: @config.access_key_id,
          secret_access_key: @config.secret_access_key,
          endpoint: @config.endpoint
        )
      end
    end
  end
end
