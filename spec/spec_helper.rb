# frozen_string_literal: true

require 'bundler/setup'
require 'cnc/storage'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Cnc::Storage.configure do |storage|
    storage.cdn_url = 'https://assets.themonk.me'
  end

  config.before do
    allow_any_instance_of(Cnc::Storage::Bucket).to receive(:upload_file).and_return(true)
  end
end
