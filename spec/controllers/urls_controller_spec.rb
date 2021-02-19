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
    let(:params) { {url: { original_url: 'http://example.com' } } }
    subject { post :create, params: params }

    it 'calls the CreateUrl interactor with the :original_url' do
      allow(CreateUrl).to receive(:call).and_return(double(:result, failure?: false))
      expect(CreateUrl).to receive(:call).with({ "original_url" => 'http://example.com' })
      subject
    end

    context 'when success creating the new URL' do
      before do
        allow(CreateUrl).to receive(:call).and_return(double(:result, failure?: false))
        subject
      end

      it { expect(response).to redirect_to urls_path }

      # it 'call the CreateUrl interactor with the original_url context' do
      #   expect(CreateUrl).to receive(:call).with({ "original_url" => 'http://example.com' })
      #   subject
      # end

      it 'set a flash success message' do
        expect(flash[:success]).to eq('URL shorten created successfully.')
      end

      it 'does not set a flash error message' do
        expect(flash[:error]).to be_nil 
      end
    end

    context 'when fails creating the new URL' do
      context 'when there are validation errors' do
        let(:context_url) { double(:context_url, errors: double(:errors, full_messages: 'Original url is wrong.')) }
        before do
          allow(CreateUrl).to receive(:call).and_return(double(:result, failure?: true, url: context_url))
          subject
        end

        it { expect(response).to redirect_to urls_path }

        it 'does not set a flash success message' do
          expect(flash[:success]).to be_nil
        end
  
        it 'set a flash error message' do
          expect(flash[:error]).to eq('Original url is wrong.') 
        end
      end

      context 'when there aren\'t validation errors' do
        let(:context_error) { 'Something was wrong.' }
        before do
          allow(CreateUrl).to receive(:call).and_return(double(:result, failure?: true, url: nil, error: context_error))
          subject
        end

        it { expect(response).to redirect_to urls_path }

        it 'does not set a flash success message' do
          expect(flash[:success]).to be_nil
        end
  
        it 'set a flash error message' do
          expect(flash[:error]).to eq('Something was wrong.') 
        end
      end
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
