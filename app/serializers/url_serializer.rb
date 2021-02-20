class UrlSerializer < ActiveModel::Serializer
  attributes :id, :original_url, :short_url, :clicks_count

  has_many :clicks
end
