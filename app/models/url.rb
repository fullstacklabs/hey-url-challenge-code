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
class Url < ApplicationRecord
  # scope :latest, -> {}
  has_many :clicks

  validates :original_url, presence: true
  validates :original_url, url: true
end
