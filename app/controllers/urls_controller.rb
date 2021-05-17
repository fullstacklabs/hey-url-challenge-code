# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.all.reverse_order.limit(10).to_a
  end

  def create
    new_url = Url.new short_url: 'AAAAA', original_url: params[:url][:original_url]
    new_url.save # XXX- not parallel! Gotta find another algorithm over record ID to solve it.

    if new_url.id.nil?
      flash[:notice] = "Bad URL: #{params[:url][:original_url]}"
    else
      new_url.short_url = ApplicationHelper.short_encode(new_url.id)
      new_url.save
      flash[:success] = "Yay, URL created as: http://localhost:3000/#{new_url.short_url}"
    end

    redirect_to action: 'index'
  end

  def show
    short_url = params[:url]
    @url = Url.find_by id: ApplicationHelper.short_decode(short_url)

    if @url.nil?
      render plain: 'I dont exist...', status: 404
    else
      clicks = Click.where("url_id = #{@url.id} and created_at > current_date - interval '10 days'").find_each.group_by(&lambda { |x| x.created_at.to_date.to_s })
      @daily_clicks = (9.days.ago.to_date..Date.today).map.with_index(1) { |day, idx| [idx.to_s, clicks[day.to_s].nil? ? 0 : clicks[day.to_s].length] }

      clicks = Click.where("url_id = #{@url.id} and created_at > current_date - interval '10 days'").find_each.group_by(&lambda { |x| x.browser })
      @browsers_clicks = clicks.keys.map { |k| [k, clicks[k].length] }

      clicks = Click.where("url_id = #{@url.id} and created_at > current_date - interval '10 days'").find_each.group_by(&lambda { |x| x.platform })
      @platform_clicks = clicks.keys.map { |k| [k, clicks[k].length] }
    end
  end

  def visit
    short_url = params[:short_url]
    url_id = ApplicationHelper.short_decode(short_url)
    url = Url.find_by id: url_id

    if url.nil?
      render plain: 'I dont exist...', status: 404
    else
      url.clicks_count += 1
      url.save

      agent = ApplicationHelper.resolve_agent(request.env['HTTP_USER_AGENT'])

      click = Click.new url_id: url.id, browser: agent[:browser], platform: agent[:platform]
      click.save
      # render plain: "redirecting to url... #{url.original_url}"
      redirect_to url.original_url
    end
  end
end
