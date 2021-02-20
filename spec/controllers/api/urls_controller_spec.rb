# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UrlsController, type: :controller do
  describe 'GET #index' do
    let!(:url) { create(:url) }

    before do
      allow(FetchUrls).to receive(:call).and_return(double(:result, urls: [url]))
      get :index
    end

    it { expect(response).to have_http_status(:ok) }

    it 'returns valid JSON' do
      body = JSON.parse(response.body)
      expect(body).to eq({
        "data"=>[
          {
            "id"=>url.id.to_s, 
            "type"=>"urls", 
            "attributes"=>{
              "original-url"=>url.original_url,
              "short-url"=>url.short_url, 
              "clicks-count"=>0
            },
            "relationships"=>{
              "clicks"=>{"data"=>[]}
            }
          }
        ]
      })
    end
  end
end
