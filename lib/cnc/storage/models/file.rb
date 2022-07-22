# frozen_string_literal: true

module Cnc
  module Storage
    class File < Base
      private

      def filename
        @filename ||= "#{::File.basename(@file, '.*')}.#{extension.subtype}"
      end

      def mime
        @mime ||= Mime.from_path(@file)
      end

      def path
        @file
      end
    end
  end
end
