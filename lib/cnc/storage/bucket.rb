# frozen_string_literal: true

module Cnc
  module Storage
    class Bucket
      class << self
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
            bucket: Cnc::Storage.config.bucket,
            acl: 'public-read',
            cache_control: 'public, max-age=31536000, immutable',
            expires: Time.now + (365 * 86_400)
          }
        end

        # using clients directly because bucket object creates a bucket, which we don't want
        def client
          @client ||= Aws::S3::Client.new(
            region: Cnc::Storage.config.region,
            access_key_id: Cnc::Storage.config.access_key_id,
            secret_access_key: Cnc::Storage.config.secret_access_key,
            endpoint: Cnc::Storage.config.endpoint
          )
        end
      end
    end
  end
end
