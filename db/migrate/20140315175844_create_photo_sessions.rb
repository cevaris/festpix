class CreatePhotoSessions < ActiveRecord::Migration
  def change
    create_table :photo_sessions do |t|
      t.string  :name
      t.integer :photo_user_id
      t.integer :event_id

      t.timestamps
    end
  end
end
