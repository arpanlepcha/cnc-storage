# Cnc::Storage
CNC::Storage is a gem to store assets/images directly to s3.
The current version of Cnc::Storage only supports image with future upgrades supporting other file formats
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cnc-storage'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cnc-storage

## Usage
- If you are using rails, add the gem to your `Gemfile`
- After that create an initializer called, `cnc_storage.rb` and define this format
```ruby
Cnc::Storage.configure do |config|
  config.bucket = 'images'
  config.endpoint = 'https://fra1.digitaloceanspaces.com'
  config.secret_access_key = '<access-key>'
  config.access_key_id = '<access-secret>'
  config.region = 'fra1'
  config.cdn_url = 'https://assets.your.domain'
end
```
- Kindly ensure that the secrets are passed from encrypted credentials and not hardcoded anywhere in your source.
- Once you have defined this, you can then use the the gem this way.
```ruby
    Cnc::Storage.by_request(params[:file], variants: [:large, :medium, :small, :extra_large])
    # OR
    Cnc::Storage.by_file(file_path) 
# this operation will return you the URL from your asset edge location.
```
Use the variants, if you want to generate the variant for an image. Currently following variants are supported.
```ruby
{
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

      }
# the array shows the dimension in pixels.
# 0th index is width, and 1st index is height. 
```
## Options
`by_request` and `by_file` takes and optional second argument, that can be used to customize your uploads.
The options are listed below

* `variants`: [String] An array of variants defined in the section above.

* `sizes`: [Integer] An array of widths in integer form, and images are resized maintaining aspect ratio.

* `async`: **Boolean** True or False. Set it to True, if you want to make the upload asynchronous, 
    else make it as false. By default it will run asynchronously

* `original`: **Boolean** True or False. Defaults to True. Whether to save
   the original file or not. If you are only generating variant, you can set it to false

* `height`: **Integer** If you want to use custom dimension for the image overriding its original dimension. 
If `width` is not given, then it will use the aspect ratio to calculate the width.  

* `width`: **Integer** If you want to use custom dimension for the image overriding its original dimension. 
If `height` is not given, then it will use the aspect ratio to calculate the height.

* `resize`: **Float** `height` or `width` will take precedence over this, but without them you can resize the image.
    Value should be in range of 0..1 

* `extension`: **String** Can be any of `png`, `jpg` or `webp`      

## Development
You can contribute to improving this gem by creating PR and merging with this.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cnc::Storage project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/arpanlepcha/cnc-storage/blob/master/CODE_OF_CONDUCT.md).
