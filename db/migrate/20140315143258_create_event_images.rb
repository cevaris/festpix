class CreateEventImages < ActiveRecord::Migration
  def self.up
    create_table :event_images do |t|
      t.integer   :event_id
      t.timestamps
    end

    add_attachment :event_images, :image
  end

  def self.down
    drop_table :event_images
  end
end
