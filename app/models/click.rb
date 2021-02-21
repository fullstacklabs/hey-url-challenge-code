# frozen_string_literal: true

class Click < ApplicationRecord
  scope :since, ->(at) { where('created_at > ?', at) }

  belongs_to :url, counter_cache: true

  validates_presence_of :browser
  validates_presence_of :platform
end
