# frozen_string_literal: true

module Cnc
  module Storage
    class Resizer
      # this class implements the resizing functionality for the images uploaded.
      def self.resize(path, options, filename = nil)
        filename ||= ::File.basename(path)
        new(path, options, filename).call do |name, image|
          if block_given?
            yield name, image
          else
            image.write_to_file("/tmp/#{name}")
          end
        end
      end

      def initialize(path, options, filename)
        @image = Vips::Image.new_from_file(path)
        @options = options
        @filename = filename
      end

      def call(&block)
        by_size(&block)
        by_variant_sizes(&block)
        by_variants(&block)
      end

      # only yield/invoke if variants are present
      def by_variants
        return if @options[:variants].nil?

        @options[:variants].each do |variant|
          dimension = ImageSize::SIZE_MATRIX[variant.to_sym]
          next if dimension.nil?

          new_image = @image.thumbnail_image(
            dimension[0],
            height: dimension[1],
            size: :force
          )
          new_filename = "#{variant}_#{@filename}"
          yield new_filename, new_image
        end
      end

      # only invoke if original is set to true in options
      def by_size
        return unless @options[:original]

        if @options[:width]
          scaling_factor = @options[:width] / Float(@image.width)
          yield @filename, @image.resize(scaling_factor)
        elsif @options[:height]
          scaling_factor = @options[:height] / Float(@image.height)
          yield @filename, @image.resize(scaling_factor)
        elsif @options[:size]
          yield @filename, @image.resize(@options[:size])
        else
          yield @filename, @image
        end
      end

      # only invoke if original is set to true in options
      # Size(s) provided via options are taken as width by default
      # scaling factor resize maintains the aspect ratio of the image
      def by_variant_sizes
        return unless @options[:sizes]

        @options[:sizes].each do |size|
          new_filename = "#{size}_#{@filename}"
          scaling_factor = size / Float(@image.width)
          yield new_filename, @image.resize(scaling_factor)
        end
      end
    end
  end
end
