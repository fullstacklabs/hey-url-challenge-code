# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :model do
  describe 'validations' do
    let(:table) { ('A'..'Z').to_a }
    let(:short_url_base_str) { 'BBBAA' }
    let(:short_url_base_value) { 703 }

    it 'short_encoding: encodes a number into a base-26 (A-Z) string' do
      short_url_str = ApplicationHelper.short_encode(short_url_base_value)
      expect(short_url_str).to eq(short_url_base_str)
    end

    it 'short_decoding: decodes a base-26 string into a number' do
      short_url_value = ApplicationHelper.short_decode(short_url_base_str)
      expect(short_url_value).to eq(short_url_base_value)
    end

    it 'random encoding' do
      10.times {
        value = rand(1...11881376)
        value_res = ApplicationHelper.short_decode(ApplicationHelper.short_encode(value))
        expect(value_res).to eq(value)
      }
    end

    it 'random decoding' do
      10.times {
        short_url_str = 5.times.map { table.sample }.join('')
        short_url_str_res = ApplicationHelper.short_encode(ApplicationHelper.short_decode(short_url_str))
        expect(short_url_str_res).to eq(short_url_str)
      }
    end
  end
end
