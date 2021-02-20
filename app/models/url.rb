# frozen_string_literal: true

# == Schema Information
#
# Table name: urls
#
#  id           :bigint           not null, primary key
#  clicks_count :integer          default(0)
#  original_url :string           not null
#  short_url    :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_urls_on_original_url  (original_url) UNIQUE
#  index_urls_on_short_url     (short_url) UNIQUE
#
class Url < ApplicationRecord
  # scope :latest, -> {}
  has_many :clicks

  validates :original_url,
            :short_url,
            presence: true
  validates :original_url,
            :short_url,
            uniqueness: true
  validates_format_of :original_url, with: URI.regexp
  validates_format_of :short_url, with: /\A[A-Z]{5,}\z/
end
