module MapHelper
  def create_map_with_places(lat, long, places)
    map = Cloudkicker::Map.new( :lat       => lat, 
                                 :long     => long,
                                 :zoom     => 12,
                                 :style_id => 10508
                                )
    places.each do |place|
      Cloudkicker::Marker.new( :map   => map, 
                               :lat   => place.latitude,
                               :long  => place.longitude, 
                               :title => 'Click to display submissions for this location.',
                               :info  => render_to_string(:partial => 'maps/_marker_tooltip', :locals => {:place => place} )
                             )
    end
    map
  end
end