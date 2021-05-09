# frozen_string_literal: true

class ClickSerializer
  include JSONAPI::Serializer
  belongs_to :url, link: true

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.month

  attributes :browser, :platform
end
