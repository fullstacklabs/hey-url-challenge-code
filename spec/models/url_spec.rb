# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
  	let(:url) { build(:url) }

  	context 'original URL' do
  		it 'Cannot be blank' do
  			url.original_url = ''
  			url.valid?
	      expect(url.errors[:original_url]).to include("can't be blank")
  		end

	  	%w(invalid_url http://invalid httpx://not.com.io http://ãíva.com https://inv@lid$url.com http://**%#xva.com).each do |path|
		    it "is not a valid URL #{path}" do
		      url.original_url = path
		      url.valid?
		      expect(url.errors[:original_url]).to include("is invalid")
		    end
		  end

		  it 'is not a valid URL http://not.com. io' do
		  	url.original_url = 'http://not.com. io'
	      url.valid?
	      expect(url.errors[:original_url]).to include("is invalid")
		  end

		  %w(http://valid.url.com http://not.com.io https://valid.com http://carina_bs8xva.com http://carina-bs8xva.com http://www.fullstacklabs.com/angular-developers).each do |path|
		    it "is a valid URL #{path}" do
		      url.original_url = path
		      expect(url.valid?).to eq(true)
		    end
		  end

		  it 'must be unique' do
		  	url_1 = create(:url)
		  	url.short_url = url_1.short_url
		  	url.valid?
		  	expect(url.errors[:short_url]).to include('has already been taken')
		  end
		end

		context 'short_url' do
			[nil, ''].each do |value|
		    it 'Cannot be valid' do
		      url.short_url = value
		      expect(url.valid?).to eq(false)
		    end

		    it 'Have to show blank message' do
		      url.short_url = value
		      url.valid?
		      expect(url.errors[:short_url]).to include("can't be blank")
		    end
		  end

		  it 'must be unique' do
		  	url_1 = create(:url, original_url: 'www.fullstacklabs.com/angular-developers', short_url: 'ABC12')
		  	url.short_url = url_1.short_url
		  	url.valid?
		  	expect(url.errors[:short_url]).to include('has already been taken')
		  end

		  %w(ABCH OJBWERP).each do |short_url|
			  it 'lenght must be 6' do
			  	url.short_url = short_url
			  	url.valid?
			  	expect(url.errors[:short_url]).to include('is the wrong length (should be 5 characters)')
			  end
			end
	  end
  end

  describe 'generate' do
  	let(:url) do
	  	build(:url, original_url: 'www.fullstacklabs.com/angular-developers')
	  end

  	it 'will generate short_url' do
  		expect{  url.generate }.to change{ Url.count }.to(1)
  	end

  	it 'will generate another short_url when there is already one with same value' do
  		create(:url, original_url: 'www.fullstacklabs_1.com/angular-developers', short_url: 'skaot')
  		expect{  url.generate }.to change{ Url.count }.to(2)
  	end

  	it 'must generate short url in uppercase' do
  		url.generate
  		expect(url.short_url).to eq(url.short_url.upcase)
  	end
  end

  describe 'clicks_per_browser' do
  	let(:url) { create(:url) }

  	it 'return number of clicks_per_browser' do
  		%i(chrome chrome mozilla).each do |browser|
  			create(:click, url: url, browser: browser)
  		end
  		expect(url.clicks_per_browser).to eq([['chrome', 2], ['mozilla', 1]])
  	end

  	it 'returns blank array when there is no click to this url' do
  		expect(url.clicks_per_browser).to eq([])
  	end
  end

  describe 'clicks_per_platform' do
  	let(:url) { create(:url) }

  	it 'return number of clicks_per_platform' do
  		%i(macos macos ubuntu ubuntu window ubuntu).each do |platform|
  			create(:click, url: url, platform: platform)
  		end
  		expect(url.clicks_per_platform).to eq([['macos', 2], ['ubuntu', 3], ['window', 1]])
  	end

  	it 'returns blank array when there is no click to this url' do
  		expect(url.clicks_per_platform).to eq([])
  	end
  end

	describe 'clicks_per_day' do
  	let(:url) { create(:url) }

  	it 'return number of clicks_per_platform' do
  		travel_to Time.local(2021, 4, 5)

  		[1.day.ago, 2.days.ago, 2.days.ago, 6.days.ago].each do |created_at|
  			create(:click, url: url, created_at: created_at)
  		end
  		expect(url.clicks_per_day).to eq([["03", 2], ["04", 1]])
  	end

  	it 'returns blank array when there is no click to this url' do
  		expect(url.clicks_per_day).to eq([])
  	end

  	it 'returns blank array when there is no click to this url on this month' do
  		travel_to Time.local(2021, 4, 3)

			create(:click, url: url, created_at: 4.days.ago)
  		expect(url.clicks_per_day).to eq([])
  	end
  end  
end
