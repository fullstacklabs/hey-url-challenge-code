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
end
