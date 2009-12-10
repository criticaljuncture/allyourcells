class AddDetailsToCellSites < ActiveRecord::Migration
  def self.up
    add_column :cell_sites, :licensee, :string
    add_column :cell_sites, :callsign, :string
    add_column :cell_sites, :location_number, :string
    add_column :cell_sites, :address, :string
    add_column :cell_sites, :city, :string
    add_column :cell_sites, :county, :string
    add_column :cell_sites, :state, :string
    add_column :cell_sites, :nepa, :string
    add_column :cell_sites, :qzone, :string
    add_column :cell_sites, :tower_reg, :string
    add_column :cell_sites, :supporting_structure_height, :float
    add_column :cell_sites, :structure_height, :float
    add_column :cell_sites, :structure_type, :string
    add_column :cell_sites, :license_id, :string
  end

  def self.down
    remove_column :cell_sites, :licensee
    remove_column :cell_sites, :callsign
    remove_column :cell_sites, :location_number
    remove_column :cell_sites, :address
    remove_column :cell_sites, :city
    remove_column :cell_sites, :county
    remove_column :cell_sites, :state
    remove_column :cell_sites, :nepa
    remove_column :cell_sites, :qzone
    remove_column :cell_sites, :tower_reg
    remove_column :cell_sites, :supporting_structure_height
    remove_column :cell_sites, :structure_height
    remove_column :cell_sites, :structure_type
    remove_column :cell_sites, :license_id
  end
end
