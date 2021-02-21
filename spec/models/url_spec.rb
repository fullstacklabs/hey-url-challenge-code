# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is a valid URL' do
      refute subject.valid?

      subject.original_url = ''
      refute subject.valid?

      subject.original_url = 'google.com'
      refute subject.valid?

      subject.original_url = 'ftp://google.com'
      refute subject.valid?

      subject.original_url = 'skype://google.com'
      refute subject.valid?

      subject.original_url = 'https://google.com'
      assert subject.valid?

      subject.original_url = 'https://google.com'
      assert subject.valid?
    end
  end
end
