# frozen_string_literal: true

# == Schema Information
#
# Table name: schools
#
#  id                     :bigint           not null, primary key
#  city                   :string
#  lat                    :float
#  lng                    :float
#  name                   :string
#  num_denied_teachers    :integer          default(0)
#  num_validated_teachers :integer          default(0)
#  state                  :string
#  teachers_count         :integer          default(0)
#  website                :string
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_schools_on_name_city_and_website  (name,city,website)
#
require "uri"
class School < ApplicationRecord
  validates :name, :city, :state, :website, presence: true
  before_save :grab_lat_lng

  has_many :teachers

  scope :validated, -> { where("num_validated_teachers > 0") }

  VALID_STATES = [ "AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY", "International"].freeze
  validates :state, inclusion: { in: VALID_STATES }
  validates_format_of :website, with: /.+\..+/, on: :create
  MAPS_API_KEY = ENV["MAPS_API_KEY"]
  GOOGLE_MAPS = "https://maps.googleapis.com/maps/api/geocode/"

  def website
    prefix_url(self[:website])
  end
  def location
    "#{city}, #{state}"
  end
  def equal(school)
    if school!=nil && self.name == school.name && self.state == school.state && self.city == school.city && school.website == self.website
      true
  else
    false
  end
  end
  private
    def prefix_url(url)
      return unless url
      url.match?(/^https?:/) ? url : "https://#{url}"
    end

    # TODO: URL encode this.
    def maps_api_location
      "#{self.city}+#{self.state.sub("International", "")}".sub(" ", "+")
    end

    def grab_lat_lng
      url = "#{GOOGLE_MAPS}json?address=#{maps_api_location}&key=#{MAPS_API_KEY}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
      req = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(req)
      data = JSON.parse(res.body)
      unless data.nil? || data["results"].empty?
        self.lat = data["results"][0]["geometry"]["location"]["lat"]
        self.lng = data["results"][0]["geometry"]["location"]["lng"]
      end
    end
end
