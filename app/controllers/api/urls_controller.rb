module Api
  class UrlsController < ApplicationController

    def index
      render json: FetchUrls.call.urls
    end
  end
end