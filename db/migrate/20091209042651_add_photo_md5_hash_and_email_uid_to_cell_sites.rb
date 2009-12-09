class AddPhotoMd5HashAndEmailUidToCellSites < ActiveRecord::Migration
  def self.up
    add_column :cell_sites, :photo_md5_hash, :string
    add_column :cell_sites, :email_uid, :integer
  end

  def self.down
    remove_column :cell_sites, :photo_md5_hash
    remove_column :cell_sites, :email_uid
  end
end
