# frozen_string_literal: true

RSpec.describe Cnc::Storage::Resizer do
  describe 'resizing options' do
    context 'with variants via variants: []' do
      it 'generates variants' do
        Cnc::Storage::Resizer.resize(
          'spec/fixtures/cnc-storage.png',
          variants: %i[thumbnail background_large]
        )
        expect(File).to exist('/tmp/thumbnail_cnc-storage.png')
        expect(File).to exist('/tmp/background_large_cnc-storage.png')
      end

      it 'generates variants by sizes' do
        Cnc::Storage::Resizer.resize(
          'spec/fixtures/cnc-storage.png',
          sizes: [200, 300, 400]
        )
        expect(File).to exist('/tmp/200_cnc-storage.png')
        expect(File).to exist('/tmp/300_cnc-storage.png')
        expect(File).to exist('/tmp/400_cnc-storage.png')
      end

      it 'takes a block' do
        expect do |block|
          Cnc::Storage::Resizer.resize(
            'spec/fixtures/cnc-storage.png',
            variants: %i[thumbnail background_large],
            &block
          )
        end.to yield_control.exactly(2).times
      end

      it 'does nothing' do
        expect do |block|
          Cnc::Storage::Resizer.resize(
            'spec/fixtures/cnc-storage.png',
            {},
            &block
          )
        end.to yield_control.exactly(0).times
      end
    end

    context 'with a width' do
      it 're-sizes the image by width' do
        Cnc::Storage::Resizer.resize('spec/fixtures/cnc-storage.png', width: 300) do |filename, image|
          expect(filename).to eq('cnc-storage.png')
          expect(image.width).to eq(300)
        end
      end
    end

    context 'with a height' do
      it 're-sizes the image by height' do
        Cnc::Storage::Resizer.resize('spec/fixtures/cnc-storage.png', height: 300) do |filename, image|
          expect(filename).to eq('cnc-storage.png')
          expect(image.height).to eq(300)
        end
      end
    end

    # image size defaults to 860x968, with resizing at 0.5 it should be 430 x 484
    context 'with a ratio' do
      it 're-sizes the image by size' do
        Cnc::Storage::Resizer.resize('spec/fixtures/cnc-storage.png', size: 0.5) do |filename, image|
          expect(filename).to eq('cnc-storage.png')
          expect(image.height).to eq(484)
          expect(image.width).to eq(430)
        end
      end
    end
  end

  describe 'alternate generation' do
    context 'with .webp extension' do
      it 'generates .webp extension' do
        Cnc::Storage::Resizer.resize(
          'spec/fixtures/cnc-storage.png',
          { original: true },
          'cnc-storage.webp'
        )
        expect(File).to exist('/tmp/cnc-storage.webp')
      end
    end
  end
end
