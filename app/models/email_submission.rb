class EmailSubmission < EmailMessage
  include GeoUtils
  attr_accessor :errors, :cell_site
  
  def initialize(message_id )
    super
    @errors = []
  end
  
  def valid?
    validate
    errors.empty?
  end
  
  def validate
    attachment_includes_gps_coordinates if has_one_jpeg_attachment
  end
  
  def latitude
    degrees_minutes_seconds = exif_data.gps_latitude
    sexagesimal_to_decimal_degrees(*degrees_minutes_seconds) unless degrees_minutes_seconds.blank?
  end
  
  def longitude
    degrees_minutes_seconds = exif_data.gps_longitude
    sexagesimal_to_decimal_degrees(*degrees_minutes_seconds) * -1 unless degrees_minutes_seconds.blank?
  end
  
  def save
    move_to('processed')
    
    if valid?
      creator = User.find_or_create_by_email!(sender_email)
      
      @cell_site = CellSite.new(
        :photo_content => jpeg_image_content,
        :lat => latitude,
        :lng => longitude,
        :email_uid => uid,
        :creator_id => creator.id,
        :updater_id => creator.id
      )
      
      if @cell_site.save
        return true
      else
        @errors << @cell_site.errors.full_messages
        @cell_site.save
        return false
      end
    else
      return false
    end
  end
  
  private
  
  def has_one_jpeg_attachment
    num_images = jpeg_attachments.size
    case num_images
    when 0
      @errors << "You must attach a JPEG image."
      return false
    when 1
      return true
    else
      @errors << "You must provide only one JPEG image attachment."
      return false
    end
  end
  
  def attachment_includes_gps_coordinates
    if has_one_jpeg_attachment
      unless longitude && latitude
        @errors << 'Your image did not include GPS coodinates.'
      end
    end
  end
  
  def jpeg_attachments
    parts.find_all{|part| part.media_type == 'IMAGE' && part.subtype == 'JPEG'}
  end
  memoize :jpeg_attachments
  
  def jpeg_image_content
    content = jpeg_attachments.first.content
    content.unpack('m').first # mime decoding
  end
  memoize :jpeg_image_content
  
  def exif_data
    exif = EXIFR::JPEG.new(StringIO.new(jpeg_image_content))
  end
  memoize :exif_data
end