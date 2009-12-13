class SpecialController < ApplicationController
  def home
    @places = []
    @lat = 37.778
    @long = -122.436
    @map = create_map_with_places(@lat, @long, @places)
  end                 
end
