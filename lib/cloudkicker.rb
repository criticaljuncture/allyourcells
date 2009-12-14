module Cloudkicker
  class Map
    def initialize(options={})
      @lat              = options.delete(:lat)              || 37.778605
      @long             = options.delete(:long)             || -122.391369
      @map_control      = options.delete(:map_control)      || true
      @map_control_type = options.delete(:map_control_type) || :large
      @zoom             = options.delete(:zoom)             || 10
      @style_id         = options.delete(:style_id)         || 2
      @bounds           = options.delete(:bounds)           || false
      @bound_points     = options.delete(:points)           || 0
      @bound_zoom       = options.delete(:bound_zoom)       || 2 #used when only a single point is passed to bound_points
      @markers          = []
    end
    
    def to_js(map_id='map')
      js = []
      js << "<script type=\"text/javascript\" src=\"#{CLOUDMADE_SRC}\"></script>"
      
      js << '<script type="text/javascript">'
      js << '$(document).ready(function() {'
      
      js << "   var cloudmade = new CM.Tiles.CloudMade.Web({key: '#{CLOUDMADE_API_KEY}', styleId: #{@style_id}});"
      js << "   var map = new CM.Map('#{map_id}', cloudmade);"
      # TODO: disable mouse zoom should be an option in an map options class
      js << "   map.disableScrollWheelZoom();"
      js << "   var added_markers = [];"
      js << "   $('.loader').show();"
      
      #add load event
      js << "   CM.Event.addListener(map, 'load', function() {"
      js << "     getMapPoints(map.getBounds());"
      js << "   });"
      
      js << "   CM.Event.addListener(map, 'dragend', function() {"
      js << "     $('.loader').show();"
      js << "     getMapPoints(map.getBounds());"
      js << "   });"
      
      js << <<-JS
      function add_markers(markers) {
        $.each(added_markers, function(i, added_marker){
          map.removeOverlay(added_marker);
        });
        added_markers = [];
        
        $.each(markers, function(i, marker){
          var myMarkerLatLng = new CM.LatLng(marker.lat,marker.lng);

          var icon = new CM.Icon();
          icon.image  = "/images/dot_med.png";
          icon.iconSize = new CM.Size(21, 21);
          //icon.shadow  = "/images/map_marker_shadow.png";
          //icon.shadowSize = new CM.Size(31, 48);
          //icon.iconAnchor = new CM.Point(20, 48);

          var myMarker = new CM.Marker(myMarkerLatLng, {
            title: marker.licensee,
            icon: icon
          });
          
          CM.Event.addListener(myMarker, 'click', function(latlng){
            map.openInfoWindow(myMarkerLatLng, parseTemplate($("#cell_site_template").html(), marker), {maxWidth: 400, pixelOffset: new CM.Size(-8,-50)});
          });
          
          
          added_markers.push(myMarker);
          map.addOverlay(myMarker);
        });
        
        $('.loader').hide();
      }

      function getMapPoints(CMBounds) {
        var sw_CMLatLng = CMBounds.getSouthWest();
        var sw_point    = [sw_CMLatLng.lat(), sw_CMLatLng.lng()]
        var ne_CMLatLng = CMBounds.getNorthEast();
        var ne_point    = [ne_CMLatLng.lat(), ne_CMLatLng.lng()]  

        $.ajax({
          type:"GET",
          url:"/cell_sites.js",
          data:"bounds={sw_point:["+sw_point+"],ne_point:["+ne_point+"]}",
          dataType:'json',
          success: add_markers
        });
      }
      JS
      
      
      if @bounds 
        if @bound_points.size > 1
          js << "   map.zoomToBounds(#{bounding_box(@bound_points)})"
        elsif @bound_points.size == 1
          js << "   map.setCenter(new CM.LatLng(#{@bound_points.first.latitude}, #{@bound_points.first.longitude}), #{@bound_zoom});"
        else
          raise "You must provide at least one point (via :bound_points) if you are using :bounds => true"
        end
      else
        js << "   map.setCenter(new CM.LatLng(#{@lat}, #{@long}), #{@zoom});"
      end
      if @map_control
        js << '   var topRight = new CM.ControlPosition(CM.TOP_RIGHT, new CM.Size(10, 10));'
        case @map_control_type.to_sym
        when :large
          js << '   map.addControl(new CM.LargeMapControl(), topRight);'
        when :small
          js << '   map.addControl(new CM.SmallMapControl(), topRight);'
        end
      end
      
      @markers.each do |marker|
        js << marker
      end
      

      js << '});' # end $(document).ready
      js << '</script>'
      js.join("\n")
    end
  
    def markers
      @markers
    end
    
    def bounding_box(points)
      # lats  = []
      # longs = []
      # points.each do |point|
      #   lats  << point.latitude
      #   longs << point.longitude
      # end
      # 
      # max_lat = lats.max
      # min_lat = lats.min
      # max_long = longs.max
      # min_long = longs.min
      # 
      # north_east_lat  = max_lat  + (max_lat  - min_lat)
      # north_east_long = max_long + (max_long - min_long)
      # 
      # south_west_lat  = min_lat  - (max_lat  - min_lat)
      # south_west_long = min_long - (max_long - min_long)
      
      cloud_map_points = []
    
      points.each do |point|
        cloud_map_points << "new CM.LatLng(#{point.latitude}, #{point.longitude})"
      end
      
      "new CM.LatLngBounds(#{cloud_map_points.join(',')})"
    end
  end
  
  class Marker
    def initialize(options={})
      raise 'Map is required'  unless options[:map]
      raise 'Lat is required'  unless options[:lat]
      raise 'Long is required' unless options[:long]
      @map   = options.delete(:map)
      @lat   = options.delete(:lat)
      @long  = options.delete(:long)
      @id    = self.object_id
      @title = options.delete(:title) || ''
      @info  = options.delete(:info)  || ''
      
      
      @info.gsub!(/\s+/, ' ')
      @max_width = options.delete(:info_max_width) || 400
      add_marker
    end
    
    private
    
    def add_marker
      js = []
      js << "   var myMarkerLatLng_#{@id} = new CM.LatLng(#{@lat},#{@long});"
      
      js << '   var icon = new CM.Icon();'
      js << '   icon.image  = "/images/map_marker.png";'
      js << '   icon.iconSize = new CM.Size(31, 48);'
      js << '   icon.shadow  = "/images/map_marker_shadow.png";'
      js << '   icon.shadowSize = new CM.Size(31, 48);'
      js << '   icon.iconAnchor = new CM.Point(20, 48);'
      
      js << "   var myMarker_#{@id} = new CM.Marker(myMarkerLatLng_#{@id}, {"
      js << "     title: '#{@title}',"
      js << "     icon: icon"
      js << '   });'
      
      # Add listener to marker
      js << "   CM.Event.addListener(myMarker_#{@id}, 'click', function(latlng) {"
      # TODO single quotes should be esacaped not deleted. Escaping doesn't seem to be working at the moment though... clearly missing something
      js << "     map.openInfoWindow(myMarkerLatLng_#{@id}, '#{@info.gsub(/'/,"")}', {maxWidth: #{@max_width}, pixelOffset: new CM.Size(-8,-50)});"
      js << '   });'
      
      js << ''
      # js << '   map.setCenter(myMarkerLatLng, 14);'
      js << "   map.addOverlay(myMarker_#{@id});"
      @map.markers << js.join("\n")
    end
  end
end