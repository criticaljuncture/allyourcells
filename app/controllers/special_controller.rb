class SpecialController < ApplicationController
  def home
    lat = 37.778
    long = -122.436
    @map = create_map(lat, long)
  end
  
  def api
  end
end
