require 'spec_helper'
require 'rails_helper'

RSpec.describe 'CreateUrl', type: :interactor do
  subject { CreateUrl.call(original_url: "http://example.com") }

  describe '.call' do
    context 'when success' do

      it { expect(subject.failure?).to eq false }

      it 'create the URL' do
        expect { subject }.to change { Url.count }.by(1)
      end

      it 'returns the last created URL' do
        expect(subject.url).to eq Url.last
      end

      it 'the URL created contains the original_url and the short_url' do
        expect(subject.url.original_url).to eq 'http://example.com'
        expect(subject.url.short_url).to match /[A-Z]{5,}/
      end
    end

    context 'when fails' do
      let(:url) { double(:url) }

      before do
        allow(Url).to receive(:new).and_return(url)
        allow(url).to receive(:save!).and_raise('internal error')
      end

      it { expect(subject.failure?).to eq true }

      it 'does not create the URL' do
        expect { subject }.to_not change { Url.count }
      end

      it 'returns a user friendly error' do
        expect(subject.error).to eq 'Failed to create the URL.'
      end
    end
  end
end
