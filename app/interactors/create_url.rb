class CreateUrl
  include Interactor

  def call
    context.url = Url.new(
      original_url: context.original_url,
      short_url: shorten_url
    )
    context.url.save!
  rescue => err
    puts err
    context.fail!(error: 'Failed to create the URL.')
  end

  private

  def shorten_url
    SecureRandom.alphanumeric.upcase.split('').map { |c| c.match(/[A-Z]/) ? c : ('A'..'Z').to_a.sample }.join
  end
end
