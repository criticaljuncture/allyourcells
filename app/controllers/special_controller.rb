class SpecialController < ApplicationController
  def home
    @map = create_map(current_location.lat, current_location.lng)
  end
  
  def api
  end
end
