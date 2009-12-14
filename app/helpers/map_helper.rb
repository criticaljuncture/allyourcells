module MapHelper
  def create_map(lat, lng, options={})
    zoom     = options.delete(:zoom)     || 12
    style_id = options.delete(:style_id) || 10508
    
    map = Cloudkicker::Map.new( :lat      => lat, 
                                :long     => lng,
                                :zoom     => zoom,
                                :style_id => style_id
                              )
  end
end