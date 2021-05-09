# frozen_string_literal: true

FactoryBot.define do
  factory :click do
    url
    browser { 'chrome' }
    platform { 'macOS' }
  end
end
