# frozen_string_literal: true

module Cnc
  module Storage
    class ImageSize
      SIZE_MATRIX = {
        thumbnail: [48, 48],
        small: [120, 120],
        medium: [320, 180],
        large: [500, 250],
        extra_large: [700, 395],
        event_large: [620, 350],
        news_medium: [320, 180],
        news_large: [460, 310],
        news_thumbnail: [135, 90],
        news_thumbnail_small: [90, 55],
        banner_xl: [2304, 320],
        banner_large: [1184, 160],
        banner_medium: [1024, 160],
        banner_small: [770, 160],
        background_xl: [2560, 1600],
        background_large: [1440, 1024],
        background_medium: [1024, 900],
        background_small: [500, 600],
        gallery_preview: [145, 85],
        gallery_thumbnail: [185, 115],
        gallery_small: [377, 151],
        gallery_large: [977, 651],
        nav_logo: [81, 36],

        app_icon_xs: [72, 72],
        app_icon_sm: [96, 96],
        app_icon_md: [128, 128],
        app_icon_xl: [152, 152],
        app_icon_xxl: [192, 192],
        app_icon_mdpi: [384, 384],
        app_icon_hdpi: [512, 512],

        app_icon_small: [96, 96],
        app_icon_medium: [128, 128],
        app_icon_large: [144, 144]
      }.freeze

      def self.valid?(sizes)
        return true if sizes.nil?

        sizes.to_set.subset?(SIZE_MATRIX.keys.to_set)
      end
    end
  end
end
