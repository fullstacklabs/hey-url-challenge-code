# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is a valid URL' do
      url = Url.new short_url: 'AAAAA', original_url: 'https://www.fullstacklabs.co'
      expect(url).to be_valid

      url = Url.new short_url: 'AAAAA', original_url: 'hxxps://www.fullstacklabs.co'
      expect(url).to_not be_valid
    end

    it 'validates short URL is present' do
      url = Url.new short_url: 'aAAAA', original_url: 'https://www.fullstacklabs.co'
      expect(url).to_not be_valid

      url = Url.new short_url: 'AAAA', original_url: 'https://www.fullstacklabs.co'
      expect(url).to_not be_valid

      url = Url.new short_url: 'AAAAAA', original_url: 'https://www.fullstacklabs.co'
      expect(url).to_not be_valid
    end

    # add more tests
  end
end
