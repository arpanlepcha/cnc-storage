# frozen_string_literal: true

require 'aws-sdk-s3'
require 'vips'
require 'marcel'
require 'dry/configurable'

require 'cnc/storage/version'

require 'cnc/storage/models/base'
require 'cnc/storage/models/file'
require 'cnc/storage/models/request'

require 'cnc/storage/bucket'
require 'cnc/storage/url_generators'
require 'cnc/storage/image_size'
require 'cnc/storage/resizer'
require 'cnc/storage/mime'
require 'cnc/storage/async/thread'

module Cnc
  module Storage
    extend Dry::Configurable

    setting :access_key_id
    setting :secret_access_key
    setting :region
    setting :bucket
    setting :endpoint
    setting :logger, default: defined?(Rails) ? Rails.logger : Logger.new($stdout)
    setting :cdn_url
    setting :debugging, default: false

    # Saves images by file, i.e the filepath in local file system
    # @param file [String]  Path to the file eg. `/tmp/devops.jpg`
    # @param options [Hash] A hash of values that can be any of
    # * `variants`: [String] An array of variants defined in the Readme.md
    # * `async`: [Boolean] True or False. Set it to True, if you want to make the upload asynchronous,
    # else make it as false. By default it will run asynchronously
    # * `original`: [Boolean] True or False. Defaults to True. Whether to save
    # the original file or not. If you are only generating variant, you can set it to false
    # * height: [Integer] Height of the original image. If width is not given, aspect ratio is considered.
    # * width: [Integer] Width of the original image. If height is not given, aspect ratio is considered.
    # * `size`: [Float] `height` or `width` will take precedence over this, but without it you can resize the image.
    # Value should be in range of 0..1
    # @return [Array[URLS]] Array of URLS that were uploaded
    def self.by_file(file, options = {})
      Cnc::Storage::File.call(file, options)
    end

    # Saves images by request, i.e the rack request
    # @param Request [Request]  Path to the file eg. `/tmp/devops.jpg`
    # @param options [Hash] A hash of values that can be any of
    # * `variants`: [String] An array of variants defined in the Readme.md
    # * `async`: [Boolean] True or False. Set it to True, if you want to make the upload
    # asynchronous, else make it as false. By default it will run asynchronously
    # * height: [Integer] Height of the original image. If width is not given, aspect ratio is considered.
    # * width: [Integer] Width of the original image. If height is not given, aspect ratio is considered.
    # * `size`: [Float] `height` or `width` will take precedence over this, but without it you can resize the image.
    # Value should be in range of 0..1
    # @return [Boolean] True if the upload was successful else False
    def self.by_request(request, options = {})
      Cnc::Storage::Request.call(request, options)
    end
  end
end
