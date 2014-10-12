class AddTrackingForCustomButton < ActiveRecord::Migration
  def self.up
    add_column :photo_sessions, :custom_button_shares, :integer, default: 0
  end

  def self.down
    remove_column :photo_sessions, :custom_button_shares
  end
end