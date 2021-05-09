# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, :type => :request do

	context 'index' do
		it 'must return 200 ok' do
			get urls_path
			expect(response).to have_http_status(:ok)
		end

		it 'must render table partial' do
			get urls_path
			expect(response).to render_template(:_table)
		end
	end

	context 'create' do
		context 'valid url' do
			it 'must return 302 Found, when is a valid url' do
				post urls_path, params: {url: {original_url: 'http://original_url.com'}}
				expect(response).to have_http_status(:found)
			end

			it 'redirects to url index' do
				post urls_path, params: {url: {original_url: 'http://original_url.com'}}
				expect(response).to redirect_to(urls_path)
			end

			it "flashes a success message not be nil" do
				post urls_path, params: {url: {original_url: 'http://original_url.com'}}
	      expect(flash[:success]).to eq('Record Created')
	    end
	  end

	  context 'invalid url' do
	  	it 'must return 302 Found, when is a valid url' do
				post urls_path, params: {url: {original_url: ''}}
				expect(response).to have_http_status(:unprocessable_entity)
			end

			it 'must return url errors' do
				post urls_path, params: {url: {original_url: 'blablavla'}}
				expect(response.body).to include("is invalid")
			end
	  end
	end

	context 'click' do
		it 'redirects to original_url' do
			url = create(:url, original_url: 'http://www.google.com')
			get visit_path(url.short_url)
			expect(response).to redirect_to(url.original_url)
		end

		it 'returns 404 page when someone tries to visit an invalid short URL' do
			get visit_path('INVAL')
			expect(response).to have_http_status(404)
		end
	end

	context 'show' do
		it 'must return 200 ok' do
			url = create(:url)
			get url_path(url.short_url)
			expect(response).to have_http_status(:ok)
		end

		it 'returns 404 page when someone tries to access an invalid short URL' do
			get url_path('INVAL')
			expect(response).to have_http_status(404)
		end
	end
end