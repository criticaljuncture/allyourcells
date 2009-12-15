class CellSite < ActiveRecord::Base
  acts_as_mappable
  include Geokit::Geocoders
  
  has_attached_file :photo#, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_uniqueness :photo
  
  validates_presence_of :lat, :lng
  
  named_scope :from_active_user, :include => :creator, :conditions => "users.id IS NULL OR users.active = 1"
  named_scope :tower, :conditions => 'license_id IS NOT NULL'
  
  named_scope :within_bounds,  Proc.new {|bounds|
    options = {}
    apply_bounds_conditions(options, Geokit::Bounds.normalize(bounds["sw_point"], bounds["ne_point"]))
    options
  }
  
  before_save :reverse_geocode, :if => Proc.new{|cell_site| cell_site.lat.present? && cell_site.state.blank?}
  
  def photo_content=(string)
    temp_file = Paperclip::Tempfile.new('photo_content.jpg')
    temp_file << string
    temp_file.flush
    
    self.photo = temp_file
  end
  
  def address2
    address2 = []
    if city.present? 
      address2 << city
    end
    if county.present? 
      address2 << county
    end
    if state.present?
      address2 << state
    end
    address2.join(', ')
  end
  
  def tower
    licensee.blank? ? false : true
  end
  
  def thumbnail_url
    photo.try(:url, :thumb)
  end
  
  private
  def reverse_geocode
    res=GoogleGeocoder.reverse_geocode([lat, lng])
    if res
      self.city = res.city
      self.address = res.street_address
      self.state = res.state
      self.county = res.province
    end
  end
  
end