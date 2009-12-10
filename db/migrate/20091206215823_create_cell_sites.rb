class CreateCellSites < ActiveRecord::Migration
  def self.up
    create_table :cell_sites do |t|
      t.float :lat, :lng
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      
      t.timestamps
      t.userstamps
    end
  end

  def self.down
    drop_table :cell_sites
  end
end
