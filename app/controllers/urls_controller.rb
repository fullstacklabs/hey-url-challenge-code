# frozen_string_literal: true

class UrlsController < ApplicationController
  # retrieve the last 10 URLs created using an API endpoint.
  def api
    urls = Url.latest(10)

    data = {
      "included": [], "data": urls.map { |url| _api_each(url) }
    }

    render json: data
  end

  def _api_each(url)
    {
      "type": "urls",
      "id": url.id,
      "attributes": {
        "created-at": url.created_at,
        "original-url": url.original_url,
        "url": visit_url(url.short_url),
        "clicks": url.clicks_count
      },
      "relationships": {
        "metrics": {
          "data": [
            {
              "id": 1,
              "type": "metrics"
            }
          ]
        }
      }
    }
  end

  # Contains the form and a list of the last 10 URL created with their click count
  def index
    @url = Url.new
    @urls = Url.latest(10)
  end

  def create
    attrs = params.require(:url).permit(:original_url)
    url = Url.new(attrs)
    if url.save
      flash[:notice] = 'Hey URL created successfully!'
      redirect_to url
    else
      flash[:alert] = "There was an error: #{url.errors.full_messages.first}"
      redirect_to urls_path
    end
  end

  # Shows the metrics associated to the short URL
  def show
    @url = Url.find_by!(short_url: params[:url])

    @daily_clicks    = _show_daily_clicks(@url)
    @browsers_clicks = _show_browsers_clicks(@url)
    @platform_clicks = _show_platform_clicks(@url)
  rescue ActiveRecord::RecordNotFound
    render plain: 'not found', status: 404
  end

  def _show_daily_clicks(url)
    dates = url.clicks.since(Date.today.beginning_of_month).pluck(:created_at)
    dates.group_by(&:to_date)
         .map { |dt, array| [dt.day, array.count] }
  end

  def _show_browsers_clicks(url)
    url.clicks.group(:browser).count.to_a
  end

  def _show_platform_clicks(url)
    url.clicks.group(:platform).count.to_a
  end

  # Redirects from a short URL to the original URL and should also track the click event
  def visit
    url = Url.find_by!(short_url: params[:url])

    browser = _visit_get_browser
    attrs = {
      browser: browser.name,
      platform: browser.platform.name
    }
    url.clicks.create! attrs

    redirect_to url.original_url
  rescue ActiveRecord::RecordNotFound
    render plain: 'not found', status: 404
  end

  def _visit_get_browser
    Browser.new request.user_agent
  end
end
