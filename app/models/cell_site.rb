class CellSite < ActiveRecord::Base
  has_attached_file :photo #, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  validates_presence_of :lat, :lng
  validates_uniqueness_of :photo_md5_hash, :full_message => "has already been uploaded."
  
  def photo_content=(string)
    temp_file = Paperclip::Tempfile.new('photo_content.jpg')
    temp_file << string
    temp_file.flush
    
    self.photo = temp_file
  end
  
  before_validation :store_photo_md5
  
  private
  
  def store_photo_md5
    self.photo_md5_hash = if photo.path
                            `md5 #{photo.path}`
                          else
                            nil
                          end
  end
end