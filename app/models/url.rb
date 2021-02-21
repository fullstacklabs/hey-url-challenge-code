# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks, dependent: :delete_all

  scope :latest, ->(n) { limit(n).order(id: :desc) }

  validates_presence_of :original_url
  validates_format_of :original_url, with: URI::regexp(%w(http https))

  after_create :assign_short_url

  def to_param
    short_url
  end

  private

  def assign_short_url
    update! short_url: id.to_s(36).rjust(5, '0')
  end
end
