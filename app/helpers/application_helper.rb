# frozen_string_literal: true

require 'browser'

module ApplicationHelper
  @@table = ('A'..'Z').to_a

  def short_encode(value)
    v = value
    s = []
    5.times do
      rest = v % 26
      s.append(@@table[rest])
      v /= 26
    end

    s.join
  end

  def short_decode(str)
    acc = 0
    str.split('').reverse.each do |char|
      rest = @@table.index(char)
      acc += rest + 26 * acc - acc
    end

    acc
  end

  def resolve_agent(user_agent)
    browser = Browser.new(user_agent)
    { :browser => browser.name, :platform => browser.platform }
  end

  module_function :short_encode, :short_decode, :resolve_agent
end
