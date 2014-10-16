class AddEventFeatures < ActiveRecord::Migration
  def self.up
    create_table :event_features do |t|
      t.integer  :event_id

      t.boolean  :facebook_share_button
      t.boolean  :twitter_share_button
      t.boolean  :instagram_share_button
      t.boolean  :download_button
      t.boolean  :download_clicked_image

      t.timestamps
    end
  end

  def self.down
    drop_table :event_features
  end
end
