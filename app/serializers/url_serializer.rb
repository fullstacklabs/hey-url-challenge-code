# frozen_string_literal: true

class UrlSerializer
  include JSONAPI::Serializer
  has_many :clicks

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.month

  attributes :original_url

  attribute :url do |object|
  	"#{Rails.application.credentials.fetch(:host)}/#{object.short_url}"
  end

  attribute :clicks do |object|
    object.clicks_count
  end

  attribute 'created-at' do |object|
  	object.created_at
  end
end
