require 'spec_helper'
require 'rails_helper'

RSpec.describe FetchUrls, type: :interactor do
  subject { FetchUrls.call }

  describe '.call' do
    let(:urls) { double() }
    before { allow(Url).to receive(:all).and_return(urls) }

    it_behaves_like :context_success

    it 'return the URLs' do
      expect(subject.urls).to eq(urls)
    end
  end
end
