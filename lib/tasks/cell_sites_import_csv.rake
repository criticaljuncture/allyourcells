namespace :cell_sites do
  namespace :import do
    task :csv => :environment do
      include GeoUtils
      
      FasterCSV.foreach("data/cell_sites.csv", :headers => :first_row) do |line|
        cell_site_attributes = line.to_hash
        cell_site_attributes.delete('lat_dir')
        cell_site_attributes.delete('lng_dir')
        
        cell_site_attributes['lat'] = sexagesimal_to_decimal_degrees(*cell_site_attributes.delete('lat_dms').split(','))
        cell_site_attributes['lng'] = sexagesimal_to_decimal_degrees(*cell_site_attributes.delete('lng_dms').split(','))
        
        cell_site = CellSite.new(cell_site_attributes)
        cell_site.save!
      end
    end
  end
end