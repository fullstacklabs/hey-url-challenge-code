# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    index_variables
  end

  def create
    @url = Url.new(permit_params)
    @url.generate
    flash[:success] = I18n.t(:record_created)
    redirect_to urls_path
    rescue StandardError
      @urls = Url.page(params[:page])
      render :index, status: :unprocessable_entity
  end

  def show
    @url = Url.find_by_short_url(params[:url]).first

    @browsers_clicks = @url.clicks_per_browser
    @platform_clicks = @url.clicks_per_platform
    @daily_clicks = @url.clicks_per_day
  rescue NoMethodError
    index_variables
    render :index, status: 404
  end

  def visit
    browser = Browser.new(request.headers['User-Agent'], accept_language: request.headers["Accept-Language"])
    redirect_to Click.create_click(params[:short_url], browser).original_url
  rescue NoMethodError
    index_variables
    render :index, status: 404
  end

  private

  def permit_params
    params.require(:url).permit(:original_url)
  end

  def index_variables
    @url = Url.new
    @urls = Url.order(:created_at).page(params[:page]).per(10)
  end
end
