# frozen_string_literal: true

RSpec.describe Cnc::Storage::Mime do
  describe '.from_path' do
    context '/tmp/arpan.pdf' do
      it 'gives invalid' do
        subject = described_class.from_path('/tmp/arpan.pdf')
        expect(subject.valid?).not_to be_truthy
      end
    end

    context '/tmp/arpan.jpg' do
      it 'gives valid' do
        subject = described_class.from_path('/tmp/arpan.jpg')
        expect(subject.valid?).to be_truthy
      end
    end
  end

  describe '.from_extension' do
    context 'pdf' do
      it 'gives invalid' do
        subject = described_class.from_extension('pdf')
        expect(subject.valid?).not_to be_truthy
      end
    end

    context 'png' do
      it 'gives valid' do
        subject = described_class.from_extension('png')
        expect(subject.valid?).to be_truthy
      end
    end
  end
end
