class AddOpenTimeToPhotoSessions < ActiveRecord::Migration
  def change
    add_column :photo_sessions, :opened_at, :datetime
  end
end
