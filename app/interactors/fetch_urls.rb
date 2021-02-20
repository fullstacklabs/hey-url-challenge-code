class FetchUrls
  include Interactor

  def call
    context.urls = Url.order(created_at: :asc).last(10)
  end
end
