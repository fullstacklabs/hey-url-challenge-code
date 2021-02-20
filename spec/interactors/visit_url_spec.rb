require 'spec_helper'
require 'rails_helper'

RSpec.describe VisitUrl, type: :interactor do
  subject { VisitUrl.call(short_url: "http://example.com", browser: 'Chrome', platform: 'Linux') }
  
  describe '.call' do
    context 'when success' do
      before do
        allow(Url).to receive(:find_by).with(short_url: "http://example.com").and_return(url)
      end

      context 'when the URL is not found' do
        let(:url) { nil }

        it_behaves_like :context_success

        it 'does not set an URL' do
          expect(subject.url).to be_nil
        end

      end

      context 'when the URL is found' do
        let(:datetime) { Time.parse('2021-02-01') }
        let(:url) { create(:url)}

        it_behaves_like :context_success

        it 'returns the URL stats' do
          expect(subject.url).to eq url
        end

        it 'create a new Click with the browser, platform and the url' do
          expect { subject }.to change { Click.count }.by(1)
          expect(Click.pluck(:browser, :platform, :url_id).last).to eq(['Chrome', 'Linux', url.id])
        end
  
        it 'increment the clicks count' do
          expect { subject }.to change { url.clicks_count }.by(1)
        end
      end
    end

    context 'when fails' do

      before do
        allow(Url).to receive(:find_by).and_raise('internal error')
      end

      it_behaves_like :context_fails

      it_behaves_like :context_with_friendly_error, 'Failed to visit the url.'
    end
  end
end
