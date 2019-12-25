class School < ActiveRecord::Base
  validates :name, :city, :state, :website, presence: true
  before_save :grab_lat_lng

  has_many :teachers

  scope :validated, -> { where("num_validated_teachers > 0") }

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

  def grab_lat_lng
    google_key = "AIzaSyC7jyOFHSorVb256ZEwvvyprp2KPjxKTPw"
    location = self.city + " " + self.state
    location.sub! " ", "+"
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=%s&key=%s" % [location, google_key]
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)
    data = JSON.parse(res.body)
    self.lat = data["results"][0]["geometry"]["location"]["lat"]
    self.lng = data["results"][0]["geometry"]["location"]["lng"]
  end
end
