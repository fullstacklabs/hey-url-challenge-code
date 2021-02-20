FactoryBot.define do
  factory :url do
    sequence(:original_url) { |i| "http://google.com/#{i}" }
    short_url  { ('A'..'Z').to_a.shuffle.join }
  end
end