class AddWatermarkToEvent < ActiveRecord::Migration
  def self.up
    add_attachment :events, :watermark

    Event.all.each do |e|
      e.watermark = e.logo.url
      e.save
    end
  end

  def self.down
    remove_attachment :events, :watermark
  end
end


