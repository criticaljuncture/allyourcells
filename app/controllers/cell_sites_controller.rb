class CellSitesController < ApplicationController
  include Geokit
  def index
    respond_to do |wants|
      wants.js { 
        bounds = params[:bounds]
        render :text => CellSite.within_bounds([bounds['sw_point'], bounds['ne_point'] ]).to_json(:only => [:lat, :lng, :licensee, :address, :id], :methods => :address2) 
      }
    end
  end
end