require 'spec_helper'
require 'rails_helper'

RSpec.describe FetchUrlStats, type: :interactor do


  subject { FetchUrlStats.call(short_url: "http://example.com") }

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
        let(:url) { double(:url, clicks: double(:clicks, on_current_month: double(:on_current_month,
            daily_clicks: [
              [datetime, 14],
              [datetime + 1.day, 10],
              [datetime + 2.day, 6],
              [datetime + 5.day, 9],
            ],
            browsers_clicks: [['Chrome', 24], ['Firefox', 10]],
            platform_clicks: [['Mac', 4], ['Window', 15]],
          ))) }

        it_behaves_like :context_success

        it 'returns the URL stats' do
          expect(subject.url).to eq url
          expect(subject.daily_clicks).to eq([['1', 14], ['2', 10], ['3', 6], ['6', 9]])
          expect(subject.browsers_clicks).to eq([['Chrome', 24], ['Firefox', 10]])
          expect(subject.platform_clicks).to eq([['Mac', 4], ['Window', 15]])
        end
      end
    end

    context 'when fails' do

      before do
        allow(Url).to receive(:find_by).and_raise('internal error')
      end

      it_behaves_like :context_fails

      it_behaves_like :context_with_friendly_error, 'Failed to retrieve URL stats.'
    end
  end
end
