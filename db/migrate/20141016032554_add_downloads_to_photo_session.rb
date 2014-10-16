class AddDownloadsToPhotoSession < ActiveRecord::Migration
  def self.up
    add_column :photo_sessions, :downloads, :integer, default: 0
  end

  def self.down
    remove_column :photo_sessions, :downloads
  end
end
