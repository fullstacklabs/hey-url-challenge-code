# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks

  scope :find_by_original_url, -> (original_url) { where(original_url: original_url) }
  scope :find_by_short_url, -> (short_url) { where(short_url: short_url) }

  validates :original_url, :short_url, presence: true
  validates :original_url, :short_url, uniqueness: true
  validate :valid_url, unless: Proc.new{|url| url.blank?}
  validates :short_url, length: { is: 5 }, unless: Proc.new{|url| url.blank?}


  def generate
    self.with_lock do
      self.short_url = generate_original_url
      self.save!
    end
  end

  def clicks_per_browser
    clicks.group(:browser).count.to_a
  end

  def clicks_per_platform
    clicks.group(:platform).count.to_a
  end

  def clicks_per_day
    clicks.from_current_month.order(:created_at_).select("TO_CHAR(created_at, 'dd') as created_at_, count(*) as quantity").group("TO_CHAR(created_at, 'dd')").map do |click|
      [click.created_at_, click.quantity]
    end
  end

  protected

  def valid_url
    if self.original_url[/^(https:\/\/|http:\/\/){0,1}(([\w|_|-]){1,}\.){1,}com(\/([\w|_|-]){1,}|\S){0,}$/].blank? || self.original_url[/((?!:\/\/)\W{1,}\w{1,}){1,}\.com.{0,}$/].blank?
      errors.add(:original_url, :invalid)
    end
  end

  def generate_original_url
    return if original_url.blank?
    random_short_url = original_url.scan(/\w{1,}/)[1..-1].join('').split('').sample(5, random: Random.new()).join('').upcase
    return random_short_url if Url.find_by_short_url(random_short_url).first.blank?
    generate_original_url
  end
end
