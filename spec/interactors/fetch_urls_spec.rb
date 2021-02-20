require 'spec_helper'
require 'rails_helper'

RSpec.describe FetchUrls, type: :interactor do
  subject { FetchUrls.call }

  describe '.call' do
    let!(:now) { Time.now }
    let!(:urls) { (1..15).map { |i| create(:url, created_at: now + i.minutes) } }

    it_behaves_like :context_success

    it 'return the last 10 URLs' do
      expect(subject.urls).to eq(urls[5..])
    end
  end
end
