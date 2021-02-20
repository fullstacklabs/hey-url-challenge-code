class VisitUrl
  include Interactor

  def call
    context.url = Url.find_by(short_url: context.short_url)
    return if context.url.nil?
    context.url.clicks_count = context.url.clicks_count + 1
    context.url.clicks << Click.new(browser: context.browser, platform: context.platform)
    context.url.save!
  rescue 
    context.fail!(error: 'Failed to visit the url.')
  end
end
