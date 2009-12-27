class SpecialController < ApplicationController
  before_filter :add_metadata_to_log
  
  def home
    @map = create_map(current_location.lat, current_location.lng)
    @recently_added = CellSite.from_active_user.all(:limit => 2, :order => "cell_sites.created_at DESC")
  end
  
  def api
  end
end
