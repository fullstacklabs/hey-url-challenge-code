# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    let(:click) { build(:click) }

    it 'validates url_id is valid' do
      click.url_id = 99
      click.save
      expect(click.errors[:url]).to include('must exist')
    end

    [nil, ''].each do |value|
      %i(browser platform).each do |attribute|
        it "validates #{attribute} is not #{value}" do
          click.send("#{attribute}=", value)
          click.save
          expect(click.errors[attribute]).to include("can't be blank")
        end
      end
    end
  end

  describe 'create_click' do
    let(:browser) do
      browser = Browser.new('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36', accept_language: 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7')
    end

    let(:url){ create(:url, clicks_count: 0) }

    it 'creates a new click' do
      expect{ Click.create_click(url.short_url, browser) }.to change{ Click.count }.to(1)
    end

    it 'have to increase click_count plus 1' do
      Click.create_click(url.short_url, browser)
      expect(url.reload.clicks_count).to eq(1)
    end
  end
end
