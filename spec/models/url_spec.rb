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
require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do

    it { is_expected.to have_many(:clicks) }
    it { is_expected.to validate_presence_of :original_url }
    it { is_expected.to validate_presence_of :short_url }

    it { is_expected.to allow_values(
      'https://foo.com',
      'https://bar.com').for(:original_url)
    }
    it { is_expected.to_not allow_values(
      'htt//foo com',
      'bar').for(:original_url)
    }

    it { is_expected.to allow_values(
      'ABCDE',
      'XYSKNLS').for(:short_url)
    }
    it { is_expected.to_not allow_values(
      'ABcDE',
      'ABC1E',
      'ABCDE  ',
      'A+BCDE',
      'ABC',
      'AB DR').for(:short_url)
    }

    it { is_expected.to validate_uniqueness_of(:original_url) }
    it { is_expected.to validate_uniqueness_of(:short_url) }
  end
end
