class CellSite < ActiveRecord::Base
  acts_as_mappable
  
  has_attached_file :photo#, :validates_attachment_uniqueness#:styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_uniqueness :photo
  
  validates_presence_of :lat, :lng
  
  named_scope :tower, :conditions => 'license_id IS NOT NULL'
  
  def photo_content=(string)
    temp_file = Paperclip::Tempfile.new('photo_content.jpg')
    temp_file << string
    temp_file.flush
    
    self.photo = temp_file
  end
  
  named_scope :within_bounds,  Proc.new {|bounds|
    options = {}
    apply_bounds_conditions(options, Geokit::Bounds.normalize(bounds["sw_point"], bounds["ne_point"]))
    options
  }
  
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
  
  # def self.return_map_pts(bounds)
  #     bounds = 
  #     
  #     find(:all, :bounds => [ bounds['sw_point'], bounds['ne_point'] ])
  #     
  #     # Cloudkicker::Marker.new( :map   => map, 
  #     #                          :lat   => place.lat
  #     #                          :long  => place.lng,
  #     #                          :title => 'Click to display submissions for this location.',
  #     #                          :info  => render_to_string(:partial => 'maps/_marker_tooltip', :locals => {:place => place} )
  #     #                        )
  #   end
end