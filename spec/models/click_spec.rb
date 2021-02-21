# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it 'validates url_id is valid' do
      refute subject.valid?
      assert_equal ["must exist"], subject.errors[:url]

      url = Url.create! original_url: 'http://google.com'
      subject.url = url
      refute subject.valid?
      assert_equal [], subject.errors[:url]
    end

    it 'validates browser is present' do
      refute subject.valid?

      subject.browser = ''
      refute subject.valid?
      assert_equal ["can't be blank"], subject.errors[:browser]

      subject.browser = 'aaaaaa'
      refute subject.valid?
      assert_equal [], subject.errors[:browser]
    end

    it 'validates platform is present' do
      refute subject.valid?

      subject.platform = ''
      refute subject.valid?
      assert_equal ["can't be blank"], subject.errors[:platform]

      subject.platform = 'aaaaaa'
      refute subject.valid?
      assert_equal [], subject.errors[:platform]
    end
  end
end
