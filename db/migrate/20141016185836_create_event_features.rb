class CreateEventFeatures < ActiveRecord::Migration
  def self.up
    create_table :event_features do |t|
      t.boolean  :facebook_share_button
      t.boolean  :twitter_share_button
      t.boolean  :instagram_share_button
      t.boolean  :download_button
      t.boolean  :download_clicked_image

      t.timestamps
    end

    add_column :events, :event_feature_id, :integer

    Event.all.each do |e|
      e.event_feature = EventFeature.new
      e.event_feature.facebook_share_button   = true
      e.event_feature.twitter_share_button    = true
      e.event_feature.instagram_share_button  = false
      e.event_feature.download_button         = true
      e.event_feature.download_clicked_image  = false
      e.event_feature.save
      e.save
    end
  end

  def self.down
    drop_table :event_features
    remove_column :events, :event_feature_id
  end
end
