class FetchUrls
  include Interactor

  def call
    context.urls = Url.all
  end
end
