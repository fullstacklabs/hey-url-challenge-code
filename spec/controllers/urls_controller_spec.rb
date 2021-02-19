# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    let(:urls) { double('urls') }

    before do
      allow(FetchUrls).to receive(:call).and_return(double(:result, failure?: false, urls: urls))
      get :index
    end

    it { expect(response).to render_template :index }

    it { expect(response).to have_http_status(:ok) }

    it 'assigns a new URL' do
      expect(assigns(:url)).to_not be_nil
      expect(assigns(:url).persisted?).to be false
    end

    it 'assigns the URLs' do
      expect(assigns(:urls)).to eq(urls)
    end

    it 'shows the latest 10 URLs' do
      skip 'add test'
    end
  end

  describe 'POST #create' do
    it 'creates a new url' do
      skip 'add test'
    end
  end

  describe 'GET #show' do
    it 'shows stats about the given URL' do
      skip 'add test'
    end

    it 'throws 404 when the URL is not found' do
      skip 'add test'
    end
  end

  describe 'GET #visit' do
    it 'tracks click event and stores platform and browser information' do
      skip 'add test'
    end

    it 'redirects to the original url' do
      skip 'add test'
    end

    it 'throws 404 when the URL is not found' do
      skip 'add test'
    end
  end
end
