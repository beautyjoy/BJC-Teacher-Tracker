class School < ActiveRecord::Base
  validates :name, :city, :state, :website, presence: true
  before_save :grab_lat_lng

  has_many :teachers

  private
    def grab_lat_lng
      self.lat = 0.0 if self.lat.nil?
      self.lng = 0.0 if self.lng.nil?
    end
end
