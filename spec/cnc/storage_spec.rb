# frozen_string_literal: true

RSpec.describe Cnc::Storage do
  let(:cdn_url) { Cnc::Storage.config.cdn_url }
  before do
    allow_any_instance_of(Cnc::Storage::Bucket).to receive(:upload_file).and_return(true)
  end

  it 'has a version number' do
    expect(Cnc::Storage::VERSION).not_to be nil
  end

  describe 'methods' do
    it 'by_file' do
      expect(Cnc::Storage.by_file('spec/fixtures/cnc-storage.png')).to(
        match_array([
          URI.join(cdn_url, 'cnc-storage.png')
        ])
      )
    end

    it 'by_file with variants' do
      expect(Cnc::Storage.by_file('spec/fixtures/cnc-storage.png', variants: %i[thumbnail small]))
        .to(match_array([
          URI.join(cdn_url, 'thumbnail_cnc-storage.png'),
          URI.join(cdn_url, 'small_cnc-storage.png'),
          URI.join(cdn_url, 'cnc-storage.png')
        ]))
    end
  end

  describe 'options' do
    context 'when original is set to false' do
      it 'does not return any image' do
        expect(Cnc::Storage.by_file('spec/fixtures/cnc-storage.png', original: false))
          .to(match_array([]))
      end
    end

    context 'when extension is set to webp' do
      it 'returns an image with webp format' do
        expect(Cnc::Storage.by_file('spec/fixtures/cnc-storage.png', extension: 'webp'))
          .to(match_array([URI.join(cdn_url, 'cnc-storage.webp')])
          )
      end
    end

    context 'when width is set' do
      it 'refer to resizer spec' do
        Cnc::Storage.by_file('spec/fixtures/cnc-storage.png', width: 100)
        Cnc::Storage.by_file('spec/fixtures/cnc-storage.png', height: 100)
        Cnc::Storage.by_file('spec/fixtures/cnc-storage.png', size: 0.5)
      end
    end
  end
end
