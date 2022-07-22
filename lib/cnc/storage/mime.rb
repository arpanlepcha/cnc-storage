# frozen_string_literal: true

module Cnc
  module Storage
    # validates whether a file is of the required type or not
    class Mime
      attr_reader :type, :mediatype, :subtype

      class << self
        def from_path(path)
          mime = Marcel::MimeType.for(name: path)
          new(mime)
        end

        def from_extension(ext)
          mime = Marcel::MimeType.for(extension: ext)
          new(mime)
        end
      end

      def initialize(type)
        @type = type
        @mediatype, @subtype = type.split('/', 2)
      end

      def valid?
        mediatype == 'image'
      end
    end
  end
end
