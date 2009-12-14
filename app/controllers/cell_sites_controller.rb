class CellSitesController < ApplicationController
  include Geokit
  def index
    if params[:per_page].blank? || params[:per_page].to_i > 500
      per_page = 50
    else
      per_page = params[:per_page]
    end
    
    search = CellSite.search(params[:search])
    @cell_sites = search.paginate(:page => params[:page], :per_page => per_page)
    
    respond_to do |wants|
      wants.js do
        if params[:fields] == "limited"
          render :json => @cell_sites.to_json(:only => [:lat, :lng, :licensee, :address, :id], :methods => :address2) 
        else
          render :json => @cell_sites
        end
      end
      wants.xml { render :xml => @cell_sites }
      wants.csv do
        columns = CellSite.columns.map(&:name)
        rows = [columns.to_csv] + @cell_sites.map{|site| columns.map{|column| site.send(column)}.to_csv}
        render :text => rows
      end
    end
  end
end