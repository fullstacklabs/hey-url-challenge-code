# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url
  validates_associated :url
  validates :browser, :platform, :url_id, presence: true

  scope :from_current_month, -> { where(created_at: 0.month.ago.beginning_of_month .. 0.month.ago.end_of_month) }

  class << self
	  def create_click(short_url, browser)
	  	url = Url.find_by_short_url(short_url).first
	  	url.transaction do
		  	Url.find_by_short_url(short_url).update_all('clicks_count = coalesce(clicks_count, 0) + 1')
		  	Click.create!(url: url, browser: browser.name, platform: browser.platform.name)
		  end
	  	url
	  end
	end
end
