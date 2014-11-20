class AddingEventFeatureFrameWatermark < ActiveRecord::Migration
  def self.up
    add_column :event_features, :is_watermark_or_frame, :boolean

    Event.all.each do |event|
      event.event_feature.is_watermark_or_frame = true
      event.save
    end
  end

  def self.down
    remove_column :event_features, :is_watermark_or_frame
  end
end
