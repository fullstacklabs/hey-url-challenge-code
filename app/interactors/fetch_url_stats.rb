class FetchUrlStats
  include Interactor

  def call
    context.url = Url.find_by(short_url: context.short_url)
    return if context.url.nil?
    clicks_on_current_month = context.url.clicks.on_current_month
    context.daily_clicks = clicks_on_current_month.daily_clicks.map { |g| [g[0].day.to_s, g[1]] }
    context.browsers_clicks = clicks_on_current_month.browsers_clicks.map { |g| [g[0], g[1]] }
    context.platform_clicks = clicks_on_current_month.platform_clicks.map { |g| [g[0], g[1]] }
  rescue
    context.fail!(error: 'Failed to retrieve URL stats.')
  end
end
