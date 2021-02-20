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
require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it { is_expected.to belong_to(:url) }

    it { is_expected.to validate_presence_of :url }
    it { is_expected.to validate_presence_of :browser }
    it { is_expected.to validate_presence_of :platform }
  end

  describe 'scopes' do
    let!(:now) { Time.parse('2020-02-19').beginning_of_day }
    let!(:day1) { now.beginning_of_month }

    # previous month
    let!(:clk_1) { create(:click, created_at: day1 - 3.days, browser: 'Chrome', platform: 'Mac') }
    let!(:clk_2) { create(:click, created_at: day1 - 3.days + 4.hours, browser: 'Chrome', platform: 'Window') }

    # day 1
    let!(:clk_3) { create(:click, created_at: day1 + 4.hours, browser: 'Safari', platform: 'Samsung') }
    let!(:clk_4) { create(:click, created_at: day1 + 7.hours, browser: 'Safari', platform: 'Mac') }
    let!(:clk_5) { create(:click, created_at: day1 + 15.hours, browser: 'Chrome', platform: 'Mac') }
    let!(:clk_6) { create(:click, created_at: day1 + 16.hours, browser: 'Chrome', platform: 'Mac') }

    # day 3
    let!(:clk_7) { create(:click, created_at: day1 + 3.days + 2.hours, browser: 'Firefox', platform: 'Window') }
    let!(:clk_8) { create(:click, created_at: day1 + 3.days + 10.hours, browser: 'Chrome', platform: 'Window') }

    # day 10
    let!(:clk_9) { create(:click, created_at: day1 + 10.days + 4.hours, browser: 'Safari', platform: 'Linux') }
    let!(:clk_10) { create(:click, created_at: day1 + 10.days + 9.hours, browser: 'Firefox', platform: 'Window') }
    let!(:clk_11) { create(:click, created_at: day1 + 10.days + 11.hours, browser: 'Chrome', platform: 'Mac') }
    let!(:clk_12) { create(:click, created_at: day1 + 10.days + 14.hours, browser: 'Chrome', platform: 'Window') }

    before do
      Timecop.freeze(now)
    end

    after { Timecop.return }

    describe '.after' do
      subject { Click.after(now.beginning_of_month + 2.days).to_a }
      it 'returns clicks created after the selected date' do
        is_expected.to eq([clk_7, clk_8, clk_9, clk_10, clk_11, clk_12])
      end
    end

    describe '.on_current_month' do
      subject { Click.on_current_month.to_a }
      it 'returns clicks created on the current month' do
        is_expected.to eq([clk_3, clk_4, clk_5, clk_6, clk_7, clk_8, clk_9, clk_10, clk_11, clk_12])
      end
    end

    describe '.daily_clicks' do
      subject { Click.daily_clicks.to_a.sort }
      it 'returns the daily clicks' do
        is_expected.to eq([
          [(day1 - 3.days).to_date, 2],
          [day1.to_date, 4],
          [(day1 + 3.days).to_date, 2],
          [(day1 + 10.days).to_date, 4],
        ].sort)
      end
    end

    describe '.browsers_clicks' do
      subject { Click.browsers_clicks.to_a.sort }
      it 'returns the browser clicks' do
        is_expected.to eq([
          ["Chrome", 7], ["Firefox", 2], ["Safari", 3]
        ].sort)
      end
    end

    describe '.platform_clicks' do
      subject { Click.platform_clicks.to_a.sort }
      it 'returns the platform clicks' do
        is_expected.to eq([
          ["Linux", 1], ["Mac", 5], ["Samsung", 1], ["Window", 5]
        ].sort)
      end
    end
  end
end
