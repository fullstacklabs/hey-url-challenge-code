module Types
  class ClickType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :url_id, Integer, null: false
    field :browser, String, null: false
    field :platform, String, null: false
  end
end
