class CellSitesController < ApplicationController
  include Geokit
  def index
    @cell_sites = CellSite.all
    
    respond_to do |wants|
      wants.js { 
        bounds = ActiveSupport::JSON.decode(params[:bounds])
        render :text => CellSite.within_bounds([bounds['sw_point'], bounds['ne_point'] ]).to_json(:only => [:lat, :lng, :licensee, :id]) 
      }
    end
  end
end