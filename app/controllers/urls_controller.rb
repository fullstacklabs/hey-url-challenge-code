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
    @url = Url.new(short_url: '123', original_url: 'http://google.com', created_at: Time.now)
    # implement queries
    @daily_clicks = [
      ['1', 13],
      ['2', 2],
      ['3', 1],
      ['4', 7],
      ['5', 20],
      ['6', 18],
      ['7', 10],
      ['8', 20],
      ['9', 15],
      ['10', 5]
    ]
    @browsers_clicks = [
      ['IE', 13],
      ['Firefox', 22],
      ['Chrome', 17],
      ['Safari', 7]
    ]
    @platform_clicks = [
      ['Windows', 13],
      ['macOS', 22],
      ['Ubuntu', 17],
      ['Other', 7]
    ]
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
