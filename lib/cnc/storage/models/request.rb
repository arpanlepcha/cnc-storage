# frozen_string_literal: true

module Cnc
  module Storage
    class Request < Base
      private

      def mime
        @mime ||= Mime.from_path(@file.original_filename)
      end

      def filename
        @filename ||= "#{SecureRandom.hex}.#{extension.subtype}"
      end

      def path
        @file.tempfile.path
      end
    end
  end
end
