# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    @url = Url.new
    result = FetchUrls.call
    @urls = result.urls
  end

  def create
    result = CreateUrl.call(url_params)
    if result.failure?
      flash[:notice] = result.url.present? ? result.url.errors.full_messages : result.error
    end
    redirect_to urls_path
  end

  def show
    result = FetchUrlStats.call(short_url: params[:url])
    if result.failure?
      flash[:notice] = result.error
      redirect_to urls_path and return
    end

    @url = result.url
    @daily_clicks = result.daily_clicks
    @browsers_clicks = result.browsers_clicks
    @platform_clicks = result.platform_clicks
  end

  def visit
    result = VisitUrl.call(
      short_url: params[:url],
      browser: browser.name,
      platform: browser.platform&.name || 'unknown'
    )
    if result.failure?
      flash[:notice] = result.error
      redirect_to urls_path and return
    end
    redirect_to result.url.original_url
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
