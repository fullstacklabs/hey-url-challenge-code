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
      flash[:error] = result.url.present? ? result.url.errors.full_messages : result.error
    else
      flash[:success] = 'URL shorten created successfully.'
    end
    redirect_to urls_path
  end

  def show
    result = FetchUrlStats.call(short_url: params[:url])
    if result.failure?
      flash[:error] = result.error
      redirect_to urls_path and return
    end
    render_not_found and return if result.url.nil?

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

    render_not_found and return if result.url.nil?
    redirect_to result.url.original_url
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
