class AddClaimToPhotoSession < ActiveRecord::Migration
  def change
    add_column :photo_sessions, :claimed, :boolean, default: false
  end
end
