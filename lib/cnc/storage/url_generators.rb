# frozen_string_literal: true

module Cnc
  module Storage
    class UrlGenerators
      def initialize(file:, path:, options:, extension:,
                     bucket: Bucket.default, config: Configuration.default)

        @file = file
        @path = path
        @options = options
        @config = config
        @bucket = bucket
        @extension = extension
      end

      def urls
        buffer = ".#{@extension.subtype}"
        urls = []

        Resizer.resize(@path, @options, @file) do |filename, image|
          upload(image, filename, buffer)
          upload_shims(image, filename) if webp?
          urls << URI.join(@config.cdn_url, filename)
        end

        urls
      end

      def upload(image, filename, buffer)
        @bucket.upload_file(
          {
            body: image.write_to_buffer(buffer),
            key: filename,
            content_type: @extension.type
          },
          async: @options[:async]
        )
      end

      def webp?
        @extension.subtype == 'webp'
      end

      # webp support is still minimalistic at the moment, so
      # add fallbacks.
      def upload_shims(image, filename)
        filename = filename.gsub('.webp', '.jpg')
        buffer = '.jpg'
        upload(image, filename, buffer)
      end
    end
  end
end
