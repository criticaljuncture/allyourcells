class CellSite < ActiveRecord::Base
  has_attached_file :photo#, :validates_attachment_uniqueness#:styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_uniqueness :photo
  
  validates_presence_of :lat, :lng
  
  def photo_content=(string)
    temp_file = Paperclip::Tempfile.new('photo_content.jpg')
    temp_file << string
    temp_file.flush
    
    self.photo = temp_file
  end
  
  # before_validation :store_photo_md5
  # 
  # private
  # 
  # def store_photo_md5
  #   self.photo_md5_hash = if photo.path
  #                           raw = `openssl md5 #{photo.path}`
  #                           raw.sub(/^.*= /, '').chomp
  #                         else
  #                           nil
  #                         end
  # end
end