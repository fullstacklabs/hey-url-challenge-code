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
end
