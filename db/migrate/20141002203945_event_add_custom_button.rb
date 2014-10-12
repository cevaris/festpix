class EventAddCustomButton < ActiveRecord::Migration
  def self.up
    add_column :events, :button_text, :string
    add_column :events, :button_url, :text
  end

  def self.down
    remove_column :events, :button_text
    remove_column :events, :button_url
  end
end
