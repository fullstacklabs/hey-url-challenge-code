# frozen_string_literal: true

# == Schema Information
#
# Table name: clicks
#
#  id         :bigint           not null, primary key
#  browser    :string           not null
#  platform   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url_id     :bigint
#
# Indexes
#
#  index_clicks_on_url_id  (url_id)
#
# Foreign Keys
#
#  fk_rails_...  (url_id => urls.id)
#
class Click < ApplicationRecord
  belongs_to :url

  scope :after, -> (datetime) { where('created_at >= ?', datetime) }
  scope :on_current_month, -> () { after(Time.now.beginning_of_month) }
  scope :daily_clicks, -> () { group('date(clicks.created_at)').count }
  scope :browsers_clicks, -> () { group(:browser).count }
  scope :platform_clicks, -> () { group(:platform).count }
end
