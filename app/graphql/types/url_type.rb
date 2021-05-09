module Types
  class UrlType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :short_url, String, null: false
    field :original_url, String, null: true
    field :clicks_count, Integer, null: false
    field :clicks, [ClickType], null: true
  end
end
