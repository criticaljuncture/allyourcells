class CellSitesController < ApplicationController
  include Geokit
  def index
    if params[:per_page].blank? || params[:per_page].to_i > 50
      per_page = 50
    else
      per_page = params[:per_page]
    end
    
    search = CellSite.search(params[:search])
    @cell_sites = search.paginate(:page => params[:page], :per_page => per_page)
    
    respond_to do |wants|
      wants.js { 
        bounds = params[:bounds]
        render :text => @cell_sites.to_json(:only => [:lat, :lng, :licensee, :address, :id], :methods => :address2) 
      }
    end
  end
end