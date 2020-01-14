# frozen_string_literal: true
require 'uri'
class School < ApplicationRecord
  validates :name, :city, :state, :website, presence: true
  before_save :grab_lat_lng

  has_many :teachers

  scope :validated, -> { where("num_validated_teachers > 0") }

  MAPS_API_KEY = "AIzaSyC7jyOFHSorVb256ZEwvvyprp2KPjxKTPw"
  GOOGLE_MAPS = "https://maps.googleapis.com/maps/api/geocode/"

  def website
    prefix_url(self[:website])
  end

  def location
    "#{city}, #{state}"
  end

  private

  def prefix_url(url)
    return unless url
    url.match(/^https?:/) ? url : "https://#{url}"
  end

  # TODO: URL encode this.
  def maps_api_location
    "#{self.city}+#{self.state}".sub(" ", "+")
  end

  def grab_lat_lng
    url = "#{GOOGLE_MAPS}?json?address=#{maps_api_location}key=#{MAPS_API_KEY}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)
    data = JSON.parse(res.body)
    self.lat = data["results"][0]["geometry"]["location"]["lat"]
    self.lng = data["results"][0]["geometry"]["location"]["lng"]
  rescue
    Rails.logger.warn("Could not set coordinates for school #{self.name}")
  end
end
