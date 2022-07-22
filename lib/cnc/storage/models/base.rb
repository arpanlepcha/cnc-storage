# frozen_string_literal: true

module Cnc
  module Storage
    class Base
      class InvalidImageFile < StandardError; end
      class InvalidImageSizes < StandardError; end

      DEFAULT_OPTIONS = {
        async: true,
        quality: 1,
        original: true
      }.freeze

      def self.call(file, options)
        new(file, options).save!
      end

      def initialize(file, options)
        @file = file
        @options = DEFAULT_OPTIONS.merge(options)
      end

      def save!
        validate!
        UrlGenerators.new(
          file: filename,
          path: path,
          options: @options,
          bucket: bucket,
          extension: extension
        ).urls
      end

      private

      def validate!
        raise InvalidImageFile unless mime.valid?
        raise InvalidImageFile unless valid_extension?
        raise InvalidImageSizes unless ImageSize.valid?(@options[:variants])
      end

      def filename
        raise NotImplementedError
      end

      def mime
        raise NotImplementedError
      end

      def path
        raise NotImplementedError
      end

      def bucket
        @bucket ||= Bucket.default
      end

      def extension
        @extension ||= begin
          ext = @options[:extension] || ::File.extname(path)
          Mime.from_extension(ext)
        end
      end

      def valid_extension?
        extension.valid?
      end
    end
  end
end
