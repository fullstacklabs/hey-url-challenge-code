class VisitUrl
  include Interactor

  def call
    context.url = Url.find_by(short_url: context.short_url)
    context.url.clicks_count = context.url.clicks_count + 1
    context.url.clicks << Click.new(browser: context.browser, platform: context.platform)
    context.url.save!
  rescue => err
    puts err
    context.fail!(error: 'Failed!')
  end
end
