class AddSocialTracking < ActiveRecord::Migration
  def self.up
    add_column :photo_sessions, :twitter_shares, :integer, default: 0
    add_column :photo_sessions, :facebook_shares, :integer, default: 0
    add_column :photo_sessions, :instagram_shares, :integer, default: 0
  end

  def self.down
    remove_column :photo_sessions, :twitter_shares
    remove_column :photo_sessions, :facebook_shares
    remove_column :photo_sessions, :instagram_shares
  end
end
