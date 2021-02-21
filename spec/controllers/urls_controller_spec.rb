# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  render_views

  describe 'GET #api' do
    it 'shows the latest 10 URLs' do
      20.times do |i|
        Url.create! original_url: "http://google.com?x=#{i}-trail"
      end
      assert_equal 20, Url.count

      get :api
      assert_response :ok

      urls = Url.all

      urls[0..9].each do |url|
        expect(response.body).not_to include url.original_url
      end

      urls[10..19].each do |url|
        expect(response.body).to include url.original_url
      end
    end
  end

  describe 'GET #index' do
    it 'shows the latest 10 URLs' do
      20.times do |i|
        Url.create! original_url: "http://google.com?x=#{i}-trail"
      end
      assert_equal 20, Url.count

      get :index
      assert_response :ok

      urls = Url.all

      urls[0..9].each do |url|
        expect(response.body).not_to include url.original_url
      end

      urls[10..19].each do |url|
        expect(response.body).to include url.original_url
      end
    end
  end

  describe 'POST #create' do
    it 'creates a new url - valid' do
      assert_equal 0, Url.count
      post :create, params: {url: { original_url: 'http://google.com' }}
      assert_response :redirect
      assert_equal 1, Url.count
      assert_redirected_to("http://test.host/urls/#{Url.last.short_url}")
    end

    it 'creates a new url - invalid' do
      assert_equal 0, Url.count
      post :create, params: {url: { original_url: 'google.com' }}
      assert_response :redirect
      assert_equal 0, Url.count
      assert_redirected_to('http://test.host/urls')
    end
  end

  describe 'GET #show' do
    it 'shows stats about the given URL' do
      assert_equal 0, Url.count
      Url.create! original_url: 'http://google.com'

      get :show, params: {url: Url.last.short_url}
      assert_response :ok
    end

    it 'throws 404 when the URL is not found' do
      assert_equal 0, Url.count

      get :show, params: {url: 'AAAAA'}
      assert_response :not_found
    end
  end

  describe 'GET #visit' do
    it 'tracks click event and stores platform and browser information' do
      assert_equal 0, Url.count
      Url.create! original_url: 'http://google.com'

      assert_equal 0, Click.count
      get :visit, params: {url: Url.last.short_url}
      assert_equal 1, Click.count
      assert_equal 1, Url.last.clicks_count
    end

    it 'redirects to the original url' do
      assert_equal 0, Url.count
      Url.create! original_url: 'http://google.com'

      get :visit, params: {url: Url.last.short_url}
      assert_redirected_to(Url.last.original_url)
    end

    it 'throws 404 when the URL is not found' do
      assert_equal 0, Url.count

      get :visit, params: {url: 'AAAAA'}
      assert_response :not_found
    end
  end
end
