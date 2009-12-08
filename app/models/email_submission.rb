class EmailSubmission < EmailMessage
  attr_accessor :errors
  
  def initialize(message_id )
    super
    @errors = []
  end
  
  def valid?
    validate
    errors.empty?
  end
  
  def validate
    has_one_jpeg_attachment
    attachment_includes_gps_coordinates
    is_from_known_user
  end
  
  def has_one_jpeg_attachment
    num_images = jpeg_attachments.size
    case num_images
    when 0
      @errors << "You must attach a JPEG image."
    when 1
    else
      @errors << "You must provide only one JPEG image attachment."
    end
    
    true
  end
  
  def attachment_includes_gps_coordinates
    exif = EXIFR::JPEG.new(jpeg_attachments.first.content.unpack('m'))
    
    # puts exif.to_hash.keys
    lng = exif.gps_longitude
    lat = exif.gps_latitude
  end
  
  def is_from_known_user
    email = "#{sender.mailbox}@#{sender.host}"
    
    # unless User.find_by_email(email)
    #   @errors << 'You are not a known user.'
    # end
  end
  
  def save!
  end
  
  private
  
  def jpeg_attachments
    parts.find_all{|part| part.media_type == 'IMAGE' && part.subtype == 'JPEG'}
  end
end