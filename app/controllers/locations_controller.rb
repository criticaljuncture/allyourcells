class LocationsController < ApplicationController
  def edit
  end
  
  def update
    location = Geokit::Geocoders::GoogleGeocoder.geocode(params[:geokit_geo_loc][:full_address])
    
    if location.success
      flash[:notice] = "Location has been changed to #{location.full_address}."
      session[:location] = location.to_hash
      redirect_to params[:redirect_to] || root_url
    else
      flash[:error] = 'We could not understand that location.'
      render :action => 'edit'
    end
  end
end