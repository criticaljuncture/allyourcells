class AddIndexToCellSites < ActiveRecord::Migration
  def self.up
    add_index :cell_sites, :lat
    add_index :cell_sites, :lng
    add_index :cell_sites, :license_id
  end

  def self.down
  end
end
