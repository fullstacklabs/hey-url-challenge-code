# frozen_string_literal: true

require 'uri'

class UrlValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :empty, "Short url is empty" if record.short_url.nil?
    record.errors.add :regex, "Short url does not match 5 capital letters" if not record.short_url.match? /^[A-Z]{5}$/
    record.errors.add :empty, "Original url is empty" if record.original_url.nil?
    record.errors.add :empty, "Original url is not valid" if not record.original_url.match? /\A#{URI::regexp(['http', 'https'])}\z/
  end
end

class Url < ApplicationRecord
  # scope :latest, -> {}
  has_many :clicks
  validates_with UrlValidator
end
